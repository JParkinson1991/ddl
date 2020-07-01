#!/usr/bin/env bash
# The following environment variables are defined in Dockerfile ARGs
# BROTLI_COMMIT, NGINX_VERSION
# camelCase variables are script local, UPPER_SNAKE_CASE are inheritied

# Define installation source file dirs
nginxSrcDir=/usr/src/nginx
nginxSrcModulesDir=/usr/src/nginx/modules

# Create installation source file dirs
mkdir -p "$nginxSrcDir"
mkdir -p "$nginxSrcModulesDir"

# Update apk repositories, add virtual build dependencies package
apk update
apk add --no-cache --virtual .build-deps \
    gcc libc-dev make openssl-dev pcre-dev zlib-dev linux-headers curl gnupg \
    libxslt-dev gd-dev geoip-dev perl-dev autoconf libtool automake git g++ cmake

# Create nginx user/group
addgroup -S nginx
adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx

# Download nginx at expected version, including its verification signature
cd "$nginxSrcDir"
wget -O nginx.tar.gz http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
wget -O nginx.tar.gz.asc http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc

# Validate the nginx installation
# Prepare gpg home dir
# Download all known nginx singing keys
export GNUPGHOME="$(mktemp -d)"
wget https://nginx.org/keys/maxim.key && gpg --import maxim.key && rm maxim.key
wget https://nginx.org/keys/sb.key && gpg --import sb.key && rm sb.key
wget https://nginx.org/keys/nginx_signing.key && gpg --import nginx_signing.key && rm nginx_signing.key
wget https://nginx.org/keys/mdounin.key && gpg --import mdounin.key && rm mdounin.key
gpg --batch --verify nginx.tar.gz.asc nginx.tar.gz
verifyExitCode=$?
rm -rf "$GNUPGHOME" nginx.tar.gz.asc
if [[ $verifyExitCode -ne 0 ]]; then
    echo "Failed to verify nginx tarball. Aborting"
    exit $verifyExitCode
fi

# Nginx tarball verified and ready to be installed at this point
# Add the brotli module
cd "$nginxSrcModulesDir"
git clone --recursive https://github.com/google/ngx_brotli.git
cd ngx_brotli
if [[ -n "$NGINX_BROTLI_COMMIT" ]] && [[ "$NGINX_BROTLI_COMMIT" != "master" ]]; then
    git checkout -b $NGINX_BROTLI_COMMIT $NGINX_BROTLI_COMMIT
    if [[ $? -ne 0 ]]; then
        echo "Failed to checkout brotli at request commit. Aborting install."
        exit $?
    fi
else
    git checkout master
fi

# Define nginx configuration
nginxConfig="
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --modules-path=/usr/lib/nginx/modules \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-cc-opt=-Wno-error \
"

# Define nginx modules for use
nginxModules="
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-http_xslt_module=dynamic \
    --with-http_image_filter_module=dynamic \
    --with-http_geoip_module=dynamic \
    --with-http_perl_module=dynamic \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --with-stream_ssl_preread_module \
    --with-stream_realip_module \
    --with-stream_geoip_module=dynamic \
    --with-http_slice_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-compat \
    --with-file-aio \
    --with-http_v2_module \
    --add-module=/usr/src/nginx/modules/ngx_brotli \
"

# Install nginx
cd "$nginxSrcDir"
mkdir nginx
tar -zxf nginx.tar.gz -C nginx --strip-components 1
cd nginx
./configure $nginxConfig $nginxModules
make -j $(getconf _NPROCESSORS_ONLN)
make install
ln -s /usr/lib/nginx/modules /etc/nginx/modules
strip /usr/sbin/nginx
strip /usr/lib/nginx/modules/*.so

# Prep run time directories
rm -rf /etc/nginx/html
mkdir -p /etc/nginx/conf.d
mkdir -p /etc/nginx/modules
mkdir -p /etc/nginx/servers
mkdir -p /var/www

# Installation cleanup
rm -rf "$nginxSrcDir" "$nginxSrcModulesDir"
apk del --purge .build-deps
