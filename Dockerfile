# 使用する PHP バージョンを最新に更新（例: PHP 8.2）
FROM php:8.2-apache

# 必要な PHP 拡張機能をインストール
RUN docker-php-ext-install pdo pdo_mysql

# Composer をインストール
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Apache の mod_rewrite を有効化
RUN a2enmod rewrite

# 作業ディレクトリを設定
WORKDIR /var/www/html

# Laravel アプリケーションをコピー
COPY src .

# storage ディレクトリが存在しない場合は作成
RUN mkdir -p storage framework/cache framework/sessions framework/views

# 権限を設定
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/framework/cache \
    && chmod -R 755 /var/www/html/framework/sessions \
    && chmod -R 755 /var/www/html/framework/views

# Apache のドキュメントルートを変更
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
