FROM php:7.4-apache

RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    && rm -rf /var/lib/apt/lists/*
RUN docker-php-ext-install pdo_mysql zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.7.1

RUN a2enmod rewrite

WORKDIR /var/www/html

COPY . .

RUN composer install --no-interaction

RUN sed -i 's|/var/www/html|/var/www/html/web|g' /etc/apache2/sites-available/000-default.conf
RUN echo "DirectoryIndex index.php" >> /etc/apache2/mods-enabled/dir.conf

RUN chown -R www-data:www-data /var/www/html/runtime /var/www/html/web/assets

EXPOSE 80

CMD ["apache2-foreground"]