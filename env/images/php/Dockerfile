FROM ddl-compiler:latest as compiler
FROM mlocati/php-extension-installer as php-extension-installer
FROM php:7.4-fpm-alpine

# Environment variables with production defaults
ENV APP_ENV="prod" \
    PHP_OPCACHE_ENABLE=1 \
    PHP_OPCACHE_REVALIDATE_FREQ=0 \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=0 \
    PHP_OPCACHE_MAX_ACCELERATED_FILES=15000 \
    PHP_OPCACHE_MEMEORY_CONSUMPTION=256 \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE=10 \
    PHP_OPCACHE_INTERNED_STRINGS_BUFFER=16 \
    PHP_OPCACHE_FAST_SHUTDOWN=1

# Copy the extension installation script
COPY --from=php-extension-installer /usr/bin/install-php-extensions /usr/bin/

# Install php extensions
RUN install-php-extensions \
    gd \
    opcache \
    && rm /usr/bin/install-php-extensions

# Copy over the configuration files
# Trailing slash indicates copy of directory contents into another directory
# Rather than copying the directory as a whole, removingdock what already exists within the dest
COPY env/images/php/config/conf.d/ $PHP_INI_DIR/conf.d/

# Set the php ini file based on the application environment
RUN if [[ $APP_ENV == "prod" ]]; then \
        mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"; \
    else \
        mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; \
    fi

COPY --from=compiler /compiled/app /var/www/app
COPY --from=compiler /compiled/public /var/www/public
COPY --from=compiler /compiled/vendor /var/www/vendor

# todo possible clean up on non php files from images
