FROM composer:latest

# Environment to compile against, default to production
ARG APP_ENV="prod"

WORKDIR /compiled

COPY composer.json composer.json
COPY composer.lock composer.lock
ADD app app
ADD system system

RUN if [[ $APP_ENV = "prod" ]]; then \
        composer install -v --no-dev; \
    else \
        composer install -v; \
    fi
