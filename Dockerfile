FROM wodby/alpine:3.6-1.1.1

ARG NGINX_VER

ENV NGINX_VER="${NGINX_VER}" \
    NGINX_UP_VER="0.9.1"

ENV NGINX_URL="http://nginx.org/download/nginx-${NGINX_VER}.tar.gz" \
    NGINX_UP_URL="https://github.com/masterzen/nginx-upload-progress-module/archive/v${NGINX_UP_VER}.tar.gz" \
    HTML_DIR="/var/www/html"

RUN set -ex; \
    \
    addgroup -S nginx; \
    adduser -S -D -H -h /var/lib/nginx -s /sbin/nologin -G nginx -g nginx nginx; \
    \
    apk add --update --no-cache --virtual .nginx-rundeps \
        geoip \
        make \
        pcre \
        sudo; \
    \
    apk add --update --no-cache --virtual .build-deps \
        autoconf \
        build-base \
        geoip-dev\
        libressl-dev \
        libtool \
        pcre-dev \
        zlib-dev; \
    \
    wget -qO- ${NGINX_URL} | tar xz -C /tmp/; \
    wget -qO- ${NGINX_UP_URL} | tar xz -C /tmp/; \
    \
    # Install nginx with modules.
    cd /tmp/nginx-${NGINX_VER}; \
    ./configure --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --pid-path=/var/run/nginx/nginx.pid \
        --lock-path=/var/run/nginx/nginx.lock \
        --http-client-body-temp-path=/var/lib/nginx/tmp/client_body \
        --http-proxy-temp-path=/var/lib/nginx/tmp/proxy \
        --http-fastcgi-temp-path=/var/lib/nginx/tmp/fastcgi \
        --http-uwsgi-temp-path=/var/lib/nginx/tmp/uwsgi \
        --http-scgi-temp-path=/var/lib/nginx/tmp/scgi \
        --user=nginx \
        --group=nginx \
        --with-pcre-jit \
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
        --with-mail \
        --with-mail_ssl_module \
        --with-http_v2_module \
        --with-ipv6 \
        --with-threads \
        --with-stream \
        --with-stream_ssl_module \
        --with-http_geoip_module \
        --with-ld-opt="-Wl,-rpath,/usr/lib/" \
        --add-module=/tmp/nginx-upload-progress-module-${NGINX_UP_VER}/; \
    \
    make -j2; \
    make install; \
    \
    # Script to fix volumes permissions via sudo.
    echo "chown nginx:nginx ${HTML_DIR}" > /usr/local/bin/fix-volumes-permissions.sh; \
    chmod +x /usr/local/bin/fix-volumes-permissions.sh; \
    \
    # Configure sudoers
    { \
        echo -n 'nginx ALL=(root) NOPASSWD: ' ; \
        echo -n '/usr/local/bin/fix-volumes-permissions.sh, ' ; \
        echo '/usr/sbin/nginx' ; \
    } | tee /etc/sudoers.d/nginx; \
    \
    mkdir -p /etc/nginx/conf.d /var/lib/nginx/tmp /etc/nginx/pki; \
    chmod -R 777 /var/lib/nginx/tmp; \
    chmod 755 /var/lib/nginx; \
    chmod 400 /etc/nginx/pki; \
    \
    chown -R nginx:nginx /etc/nginx; \
    \
    # Cleanup
    apk del .build-deps; \
    rm -rf /tmp/*; \
    rm -rf /var/cache/apk/*

USER nginx

COPY actions /usr/local/bin
COPY templates /etc/gotpl/
COPY docker-entrypoint.sh /

WORKDIR $HTML_DIR
EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sudo", "nginx"]
