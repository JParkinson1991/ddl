FROM ddl-compiler:latest as compiler
FROM nginx:1-alpine

# Copy nginx config
COPY env/images/nginx/config/nginx.conf /etc/nginx/nginx.conf
COPY env/images/nginx/config/servers /etc/nginx/servers
COPY env/images/nginx/config/conf.d /etc/nginx/conf.d

# App app directory to web root
COPY --from=compiler /compiled/app /var/www
