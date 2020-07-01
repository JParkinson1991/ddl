FROM composer:latest

# Environment to compile against, default to production
ARG APP_ENV="prod"

# Copy in the cache from the host
# The cache folder may not exist, so some workarounds are required
# Essentially as long as COPY recieves one valid file to copy it will not error
# Therefore, copying composer.json which does exist and then a wildcard cache dir we can copy the cache only if
# it exists, and if it does not no errors are thrown.
# We must remove composer.json after this copy however
COPY composer.json var/cache/composer* $COMPOSER_HOME/cache/

# Set work dir, relative copies, shell home etc resolved from here
WORKDIR /compiled

# Add host source
COPY composer.json composer.json
COPY composer.lock composer.lock
ADD app app
ADD system system

# Build the source
# Remove workaround composer.json prior to this
RUN rm $COMPOSER_HOME/cache/composer.json \
    && if [[ $APP_ENV == "prod" ]]; then \
        composer install -v --no-dev; \
    else \
        composer install -v; \
    fi
