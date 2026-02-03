FROM php:8.1-apache
WORKDIR /var/www/html

RUN docker-php-ext-install pdo pdo_mysql \
    && a2enmod rewrite

COPY . /var/www/html/

EXPOSE 80