ARG BASE_IMAGE_TAG

FROM wodby/alpine:${BASE_IMAGE_TAG}

ARG NGINX_VER

ARG WODBY_USER_ID=1000
ARG WODBY_GROUP_ID=1000

ENV NGINX_VER="${NGINX_VER}" \
    APP_ROOT="/var/www/html" \
    FILES_DIR="/mnt/files" \
    NGINX_VHOST_PRESET="html"

RUN set -ex; \
    \
    nginx_up_ver="0.9.3"; \
    brotli_commit='9aec15e2aa6feea2113119ba06460af70ab3ea62'; \
    vts_commit='3c6cf41315bfcb48c35a3a0be81ddba6d0d01dac'; \
    \
    addgroup -S nginx; \
    adduser -S -D -H -h /var/cache/nginx -s /sbin/nologin -G nginx nginx; \
    \
	addgroup -g "${WODBY_GROUP_ID}" -S wodby; \
	adduser -u "${WODBY_USER_ID}" -D -S -s /bin/bash -G wodby wodby; \
	sed -i '/^wodby/s/!/*/' /etc/shadow; \
	echo "PS1='\w\$ '" >> /home/wodby/.bashrc; \
    \
    apk add --update --no-cache -t .tools \
        findutils \
        make \
        nghttp2 \
        openssl \
        sudo; \
    \
    apk add --update --no-cache -t .nginx-build-deps \
        apr-dev \
        apr-util-dev \
        build-base \
        brotli-dev \
        gd-dev \
        git \
        gnupg \
        gperf \
        icu-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libtool \
        libxslt-dev \
        linux-headers \
        openssl-dev \
        pcre-dev \
        zlib-dev; \
     \
    # Brotli.
    cd /tmp; \
    git clone --depth 10 --single-branch https://github.com/google/ngx_brotli; \
    cd /tmp/ngx_brotli; \
    git checkout ${brotli_commit}; \
    \
    # Get ngx upload progress module. \
    mkdir -p /tmp/ngx_http_uploadprogress_module; \
    url="https://github.com/masterzen/nginx-upload-progress-module/archive/v${nginx_up_ver}.tar.gz"; \
    wget -qO- "${url}" | tar xz --strip-components=1 -C /tmp/ngx_http_uploadprogress_module; \
    \
    export GPG_KEYS=0AB1A7CA1283FF69D0E5F483E79FE70A6F23EB22; \
    # Get VTS module \
    git clone https://github.com/vozlt/nginx-module-vts.git /tmp/nginx_module_vts; \
    cd /tmp/nginx_module_vts; \
    git checkout ${vts_commit}; \
    \
    # Download nginx.
    curl -fSL "https://nginx.org/download/nginx-${NGINX_VER}.tar.gz" -o /tmp/nginx.tar.gz; \
    curl -fSL "https://nginx.org/download/nginx-${NGINX_VER}.tar.gz.asc"  -o /tmp/nginx.tar.gz.asc; \
    gpg_verify /tmp/nginx.tar.gz.asc /tmp/nginx.tar.gz; \
    tar zxf /tmp/nginx.tar.gz -C /tmp; \
    \
    cd "/tmp/nginx-${NGINX_VER}"; \
    ./configure \
        --prefix=/usr/share/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --pid-path=/var/run/nginx/nginx.pid \
        --lock-path=/var/run/nginx/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=nginx \
        --group=nginx \
        --with-compat \
        --with-file-aio \
        --with-http_addition_module \
        --with-http_auth_request_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
		--with-http_image_filter_module=dynamic \
        --with-http_mp4_module \
        --with-http_random_index_module \
        --with-http_realip_module \
        --with-http_secure_link_module \
		--with-http_slice_module \
        --with-http_ssl_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_v2_module \
		--with-http_xslt_module=dynamic \
        --with-ipv6 \
        --with-ld-opt="-Wl,-z,relro,--start-group -lapr-1 -laprutil-1 -licudata -licuuc -lpng -lturbojpeg -ljpeg" \
        --with-mail \
        --with-mail_ssl_module \
        --with-pcre-jit \
        --with-stream \
        --with-stream_ssl_module \
		--with-stream_ssl_preread_module \
		--with-stream_realip_module \
        --with-threads \
        --add-module=/tmp/ngx_http_uploadprogress_module \
        --add-module=/tmp/ngx_brotli \
        --add-module=/tmp/nginx_module_vts; \
    \
    make -j$(getconf _NPROCESSORS_ONLN); \
    make install; \
    mkdir -p /usr/share/nginx/modules; \
    \
    install -g wodby -o wodby -d \
        "${APP_ROOT}" \
        "${FILES_DIR}" \
        /etc/nginx/conf.d \
        /var/cache/nginx \
        /var/lib/nginx; \
    \
    touch /etc/nginx/upstream.conf; \
    chown -R wodby:wodby /etc/nginx; \
    \
    install -m 400 -d /etc/nginx/pki; \
    strip /usr/sbin/nginx*; \
    strip /usr/lib/nginx/modules/*.so; \
    \
    for i in /usr/lib/nginx/modules/*.so; do ln -s "${i}" /usr/share/nginx/modules/; done; \
    \
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-cache --virtual .nginx-rundeps $runDeps; \
    \
    # Script to fix volumes permissions via sudo.
    echo "find ${APP_ROOT} ${FILES_DIR} -maxdepth 0 -uid 0 -type d -exec chown -f wodby:wodby {} +" > /usr/local/bin/init_volumes; \
    chmod +x /usr/local/bin/init_volumes; \
    \
    { \
        echo "Defaults secure_path=\"$PATH\""; \
        echo 'Defaults env_keep += "APP_ROOT FILES_DIR NGINX_VHOST_PRESET"' ; \
        echo -n 'wodby ALL=(root) NOPASSWD:SETENV: ' ; \
        echo -n '/usr/local/bin/init_volumes, ' ; \
        echo '/usr/sbin/nginx' ; \
    } | tee /etc/sudoers.d/wodby; \
    \
    chown wodby:wodby /usr/share/nginx/html/50x.html; \
    \
    apk del --purge .nginx-build-deps; \
    rm -rf \
        /tmp/* \
        /var/cache/apk/* ;

USER wodby

COPY bin /usr/local/bin
COPY templates /etc/gotpl/
COPY docker-entrypoint.sh /

WORKDIR $APP_ROOT
EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sudo", "nginx"]
