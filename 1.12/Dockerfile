FROM alpine:3.6

ENV NGINX_VER 1.12.0
ENV NGINX_UP_VER 0.9.1
ENV GOTPL_VER 0.1.5
ENV HTML_DIR /var/www/html

RUN set -ex && \
    addgroup -S -g 82 www-data && \
    adduser -S -u 82 -s /bin/bash -D -G www-data www-data && \

    addgroup -S nginx && \
    adduser -S -D -H -h /var/lib/nginx -s /sbin/nologin -G nginx -g nginx nginx && \
    addgroup nginx www-data && \

    apk --update add \
        bash \
        ca-certificates \
        curl \
        geoip \
        make \
        pcre \
        su-exec \
        wget \

        # Temporarily packages to compilation
        autoconf \
        build-base \
        geoip-dev\
        libressl-dev \
        libtool \
        pcre-dev \
        zlib-dev && \

    wget -qO- https://github.com/wodby/gotpl/releases/download/${GOTPL_VER}/gotpl-alpine-linux-amd64-${GOTPL_VER}.tar.gz | tar xz -C /usr/local/bin && \

    wget -qO- http://nginx.org/download/nginx-${NGINX_VER}.tar.gz | tar xz -C /tmp/ && \
    wget -qO- https://github.com/masterzen/nginx-upload-progress-module/archive/v${NGINX_UP_VER}.tar.gz | tar xz -C /tmp/ && \

    # Make and install nginx with module
    cd /tmp/nginx-${NGINX_VER} && \
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
        --add-module=/tmp/nginx-upload-progress-module-${NGINX_UP_VER}/ && \

    make -j2 && \
    make install && \

    mkdir /etc/nginx/conf.d && \
    mkdir -p /var/lib/nginx/tmp && \
    chmod 755 /var/lib/nginx && \
    chmod -R 777 /var/lib/nginx/tmp && \
    mkdir -p /etc/nginx/pki && \
    chmod 400 /etc/nginx/pki && \

    # Cleanup
    apk del *-dev build-base autoconf libtool && \
    rm -rf /var/cache/apk/* /tmp/*

COPY actions /usr/local/bin

WORKDIR $HTML_DIR
EXPOSE 80

COPY templates/* /etc/gotpl/
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx"]
