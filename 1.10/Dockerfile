FROM alpine:3.5

ENV NGINX_VER 1.10.2
ENV NGINX_UP_VER 0.9.1
ENV NGINX_NDK_VER 0.3.0
ENV NGINX_NXS_VER 0.54
ENV NGINX_LUA_VER 0.10.7
ENV LUAJIT_LIB /usr/lib/
ENV LUAJIT_INC /usr/include/luajit-2.1/
ENV GOTLP_VER 0.1.5

    # Create user and groups
    # Based on http://git.alpinelinux.org/cgit/aports/tree/main/nginx-initscripts/nginx-initscripts.pre-install
RUN addgroup -S -g 82 www-data && \
    adduser -S -u 82 -s /bin/bash -D -G www-data www-data && \

    addgroup -S nginx && \
    adduser -S -D -H -h /var/lib/nginx -s /sbin/nologin -G nginx -g nginx nginx && \
    addgroup nginx www-data && \

    # Prepare build tools for compiling some applications from source code
    apk --update add \
        bash \
        ca-certificates \
        wget \
        pcre \
        build-base \
        autoconf \
        libtool \
        geoip \
        libressl-dev \
        pcre-dev \
        zlib-dev \
        geoip-dev\
        luajit \
        luajit-dev && \

    # Download and install Gotlp
    wget -qO- https://github.com/wodby/gotpl/releases/download/${GOTLP_VER}/gotpl-alpine-linux-amd64-${GOTLP_VER}.tar.gz | tar xz -C /usr/local/bin && \

    # Download nginx and its modules source code
    wget -qO- http://nginx.org/download/nginx-${NGINX_VER}.tar.gz | tar xz -C /tmp/ && \
    wget -qO- https://github.com/simpl/ngx_devel_kit/archive/v${NGINX_NDK_VER}.tar.gz | tar xz -C /tmp/ && \
    wget -qO- https://github.com/masterzen/nginx-upload-progress-module/archive/v${NGINX_UP_VER}.tar.gz | tar xz -C /tmp/ && \
    wget -qO- https://github.com/nbs-system/naxsi/archive/${NGINX_NXS_VER}.tar.gz | tar xz -C /tmp/ && \
    wget -qO- https://github.com/openresty/lua-nginx-module/archive/v${NGINX_LUA_VER}.tar.gz | tar xz -C /tmp/ && \

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
        --add-module=/tmp/ngx_devel_kit-${NGINX_NDK_VER}/ \
        --add-module=/tmp/nginx-upload-progress-module-${NGINX_UP_VER}/ \
        --add-module=/tmp/naxsi-${NGINX_NXS_VER}/naxsi_src/ \
        --add-module=/tmp/lua-nginx-module-${NGINX_LUA_VER}/ && \
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

WORKDIR /var/www/html
EXPOSE 80

COPY templates/* /etc/gotpl/
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["nginx"]
