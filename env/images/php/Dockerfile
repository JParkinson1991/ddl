FROM ddl-compiler:latest as compiler
FROM php:7.4-fpm-alpine

COPY --from=compiler /compiled/app /var/www
