FROM wodby/alpine:3.6-1.2.0

ARG NGINX_VER

ENV NGINX_VER="${NGINX_VER}" \
    NGINX_UP_VER="0.9.1" \
    HTML_DIR="/var/www/html"

RUN set -ex; \
    \
    addgroup -S nginx; \
    adduser -S -D -H -h /var/cache/nginx -s /sbin/nologin -G nginx nginx; \
    \
    apk add --update --no-cache -t .nginx-rundeps \
        geoip \
        make \
        pcre \
        sudo; \
    \
    apk add --update --no-cache -t .nginx-build-deps \
        autoconf \
        build-base \
        geoip-dev\
        gnupg \
        libressl-dev \
        libtool \
        pcre-dev \
        zlib-dev; \
    \
    curl -fSL "https://nginx.org/download/nginx-${NGINX_VER}.tar.gz" -o /tmp/nginx.tar.gz; \
    curl -fSL "https://nginx.org/download/nginx-${NGINX_VER}.tar.gz.asc"  -o /tmp/nginx.tar.gz.asc; \
    GPG_KEYS=B0F4253373F8F6F510D42178520A9993A1C052F8 gpg-verify.sh /tmp/nginx.tar.gz.asc /tmp/nginx.tar.gz; \
    \
    tar zxf /tmp/nginx.tar.gz -C /tmp; \
    \
    wget -qO- "https://github.com/masterzen/nginx-upload-progress-module/archive/v${NGINX_UP_VER}.tar.gz" \
        | tar xz -C /tmp; \
    \
    cd "/tmp/nginx-${NGINX_VER}"; \
    ./configure \
        --prefix=/usr/share/nginx \
        --sbin-path=/usr/sbin/nginx \
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
        --add-module="/tmp/nginx-upload-progress-module-${NGINX_UP_VER}/"; \
    \
    make -j$(getconf _NPROCESSORS_ONLN); \
    make install; \
    \
    mkdir -p \
        "${HTML_DIR}" \
        /etc/nginx/conf.d \
        /var/lib/nginx/tmp \
        /etc/nginx/pki; \
    \
    chown -R nginx:nginx \
        "${HTML_DIR}" \
        /etc/nginx \
        /var/lib/nginx; \
    \
    chmod 755 /var/lib/nginx; \
    chmod 400 /etc/nginx/pki; \
    \
    # Cleanup
    apk del --purge .nginx-build-deps; \
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
