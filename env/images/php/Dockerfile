FROM ddl-compiler:latest as compiler
FROM php:7.4-fpm-alpine

# Environment variables with production defaults
ENV APP_ENV="prod"

COPY --from=compiler /compiled/app /var/www/app
COPY --from=compiler /compiled/public /var/www/public
COPY --from=compiler /compiled/vendor /var/www/vendor
