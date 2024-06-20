# Utilisez une image de base officielle de PHP avec FPM et Alpine
FROM php:8.3-fpm-alpine

# Installez les extensions PHP nécessaires
RUN docker-php-ext-install pdo pdo_pgsql

# Installez Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Définissez le répertoire de travail
WORKDIR /var/www/html

# Copiez les fichiers de l'application
COPY . .

# Installez les dépendances PHP
RUN composer install --no-dev --optimize-autoloader

# Changez les permissions du répertoire de stockage et du cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exposez le port 9000 et démarrez PHP-FPM
EXPOSE 9000
CMD ["php-fpm"]
