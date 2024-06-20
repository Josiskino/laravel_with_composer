# Utilisez une image de base officielle de PHP avec FPM et Alpine
FROM php:8.3-fpm-alpine

# Installez les extensions PHP nécessaires, y compris pdo_pgsql
RUN apk add --no-cache \
        postgresql-dev \
    && docker-php-ext-install \
        pdo \
        pdo_pgsql

# Installer les dépendances nécessaires pour Composer
RUN apk add --no-cache git unzip curl

# Téléchargez et installez Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Définissez le répertoire de travail
WORKDIR /var/www/html

# Copiez les fichiers de l'application
COPY . .

# Installez les dépendances PHP
RUN composer install --no-dev --optimize-autoloader

# Changez les permissions du répertoire de stockage et du cache
RUN chown -R www-data:www-data:w /var/www/html/storage /var/www/html/bootstrap/cache

# Exposez le port 9000 et démarrez PHP-FPM
EXPOSE 9000
CMD ["php-fpm"]
