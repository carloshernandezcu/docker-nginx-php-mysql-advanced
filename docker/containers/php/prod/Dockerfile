FROM giffits/php-base

# Copy codebase (backend)
COPY ./api /var/www/api
RUN chown -R www-data:www-data /var/www

# Install php dependencies
RUN cd /var/www/api && sudo -u www-data composer install
