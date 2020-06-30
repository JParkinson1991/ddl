FROM ddl-compiler:latest as compiler
FROM mlocati/php-extension-installer as php-extension-installer
FROM php:7.4-fpm-alpine

# Environment variables with production defaults
ENV APP_ENV="prod"

# Copy the extension installation script
COPY --from=php-extension-installer /usr/bin/install-php-extensions /usr/bin/

# Install php extensions
RUN install-php-extensions \
    gd \
    && rm /usr/bin/install-php-extensions

COPY --from=compiler /compiled/app /var/www/app
COPY --from=compiler /compiled/public /var/www/public
COPY --from=compiler /compiled/vendor /var/www/vendor

# todo possible clean up on non php files from images
