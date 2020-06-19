FROM ddl-compiler:latest as compiler
FROM alpine:3.12

ARG BROTLI_COMMIT="master"
ARG NGINX_VERSION=1.18.0

# Copy alpine initialiser
COPY env/common/scripts/alpine_init.sh alpine_init.sh
COPY env/images/nginx/scripts/nginx_install.sh nginx_install.sh

# Copy nginx config
COPY env/images/nginx/config/nginx.conf /etc/nginx/nginx.conf
COPY env/images/nginx/config/conf.d /etc/nginx/conf.d
COPY env/images/nginx/config/modules /etc/nginx/modules
COPY env/images/nginx/config/servers /etc/nginx/servers

# Execute initialisation scripts
# - Run the alpine init script in shell sh
# - Run the nginx install script in bash
RUN chmod +x alpine_init.sh && /bin/sh alpine_init.sh && rm alpine_init.sh
RUN chmod +x nginx_install.sh && /bin/bash nginx_install.sh && rm nginx_install.sh

# App app directory to web root
# todo php entry points, remove all but
COPY --from=compiler /compiled/app /var/www

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]

WORKDIR /var/www
