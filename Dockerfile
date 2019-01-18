ARG BASE_IMAGE_TAG

FROM wodby/alpine:${BASE_IMAGE_TAG}

ARG NGINX_VER

ENV NGINX_VER="${NGINX_VER}" \
    NGINX_UP_VER="0.9.1" \
    MOD_PAGESPEED_VER=1.13.35.2 \
    NGX_PAGESPEED_VER=1.13.35.2 \
    APP_ROOT="/var/www/html" \
    FILES_DIR="/mnt/files" \
    NGINX_VHOST_PRESET="html" \
    NGX_MODSECURITY_VER="1.0.0" \
    MODSECURITY_VER="3.0.3" \
    OWASP_CRS_VER="3.1.0"

RUN set -ex; \
    \
    addgroup -S nginx; \
    adduser -S -D -H -h /var/cache/nginx -s /sbin/nologin -G nginx nginx; \
    \
	addgroup -g 1000 -S wodby; \
	adduser -u 1000 -D -S -s /bin/bash -G wodby wodby; \
	sed -i '/^wodby/s/!/*/' /etc/shadow; \
	echo "PS1='\w\$ '" >> /home/wodby/.bashrc; \
    \
    apk add --update --no-cache -t .tools \
        findutils \
        make \
        nghttp2 \
        sudo; \
    \
    apk add --update --no-cache -t .nginx-build-deps \
        apr-dev \
        apr-util-dev \
        build-base \
        gd-dev \
        git \
        gnupg \
        gperf \
        icu-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libressl-dev \
        libtool \
        libxslt-dev \
        linux-headers \
        pcre-dev \
        zlib-dev; \
     \
     apk add --no-cache -t .libmodsecurity-build-deps \
        autoconf \
        automake \
        bison \
        curl \
        flex \
        g++ \
        git \
        libmaxminddb-dev \
        libstdc++ \
        libtool \
        libxml2-dev \
        pcre-dev \
        rsync \
        sed \
        yajl \
        yajl-dev; \
    \
    # Modsecurity lib.
    cd /tmp; \
    git clone --depth 1 -b "v${MODSECURITY_VER}" --single-branch https://github.com/SpiderLabs/ModSecurity; \
    cd ModSecurity; \
    git submodule init;  \
    git submodule update; \
    ./build.sh; \
    ./configure --disable-doxygen-doc --disable-doxygen-html; \
    make -j$(getconf _NPROCESSORS_ONLN); \
    make install;  \
    mkdir -p /etc/nginx/modsecurity/; \
    mv modsecurity.conf-recommended /etc/nginx/modsecurity/recommended.conf;  \
    sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/nginx/modsecurity/recommended.conf; \
    cp unicode.mapping /etc/nginx/modsecurity/; \
    rsync -a --links /usr/local/modsecurity/lib/libmodsecurity.so* /usr/local/lib/; \
    \
    # Get ngx modsecurity module.
    mkdir -p /tmp/ngx_http_modsecurity_module; \
    ver="${NGX_MODSECURITY_VER}"; \
    url="https://github.com/SpiderLabs/ModSecurity-nginx/releases/download/v${ver}/modsecurity-nginx-v${ver}.tar.gz"; \
    wget -qO- "${url}" | tar xz --strip-components=1 -C /tmp/ngx_http_modsecurity_module; \
    \
    # OWASP.
    wget -qO- "https://github.com/SpiderLabs/owasp-modsecurity-crs/archive/v${OWASP_CRS_VER}.tar.gz" | tar xz -C /tmp; \
    cd /tmp/owasp-modsecurity-crs-*; \
    sed -i "s#SecRule REQUEST_COOKIES|#SecRule REQUEST_URI|REQUEST_COOKIES|#" rules/REQUEST-941-APPLICATION-ATTACK-XSS.conf; \
    mkdir -p /etc/nginx/modsecurity/crs/; \
    mv crs-setup.conf.example /etc/nginx/modsecurity/crs/setup.conf; \
    mv rules /etc/nginx/modsecurity/crs; \
    \
    # Get ngx pagespeed module.
    git clone -b "v${NGX_PAGESPEED_VER}-stable" \
          --recurse-submodules \
          --shallow-submodules \
          --depth=1 \
          -c advice.detachedHead=false \
          -j$(getconf _NPROCESSORS_ONLN) \
          https://github.com/apache/incubator-pagespeed-ngx.git \
          /tmp/ngx_pagespeed; \
    \
    # Get psol for alpine.
    url="https://github.com/wodby/nginx-alpine-psol/releases/download/${MOD_PAGESPEED_VER}/psol.tar.gz"; \
    wget -qO- "${url}" | tar xz -C /tmp/ngx_pagespeed; \
    \
    # Get ngx uploadprogress module.
    mkdir -p /tmp/ngx_http_uploadprogress_module; \
    url="https://github.com/masterzen/nginx-upload-progress-module/archive/v${NGINX_UP_VER}.tar.gz"; \
    wget -qO- "${url}" | tar xz --strip-components=1 -C /tmp/ngx_http_uploadprogress_module; \
    \
    # Download nginx.
    curl -fSL "https://nginx.org/download/nginx-${NGINX_VER}.tar.gz" -o /tmp/nginx.tar.gz; \
    curl -fSL "https://nginx.org/download/nginx-${NGINX_VER}.tar.gz.asc"  -o /tmp/nginx.tar.gz.asc; \
    GPG_KEYS=B0F4253373F8F6F510D42178520A9993A1C052F8 gpg_verify /tmp/nginx.tar.gz.asc /tmp/nginx.tar.gz; \
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
        --add-dynamic-module=/tmp/ngx_pagespeed \
        --add-dynamic-module=/tmp/ngx_http_modsecurity_module; \
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
    install -g nginx -o nginx -d \
        /var/cache/ngx_pagespeed \
        /pagespeed_static \
        /ngx_pagespeed_beacon; \
    \
    install -m 400 -d /etc/nginx/pki; \
    strip /usr/sbin/nginx*; \
    strip /usr/lib/nginx/modules/*.so; \
    strip /usr/local/lib/libmodsecurity.so*; \
    \
    for i in /usr/lib/nginx/modules/*.so; do ln -s "${i}" /usr/share/nginx/modules/; done; \
    \
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' /usr/sbin/nginx /usr/local/modsecurity/lib/*.so /usr/lib/nginx/modules/*.so /tmp/envsubst \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --no-cache --virtual .nginx-rundeps $runDeps; \
    \
    # Script to fix volumes permissions via sudo.
    echo "find ${APP_ROOT} ${FILES_DIR} -maxdepth 0 -uid 0 -type d -exec chown wodby:wodby {} +" > /usr/local/bin/init_volumes; \
    chmod +x /usr/local/bin/init_volumes; \
    \
    { \
        echo -n 'wodby ALL=(root) NOPASSWD:SETENV: ' ; \
        echo -n '/usr/local/bin/init_volumes, ' ; \
        echo '/usr/sbin/nginx' ; \
    } | tee /etc/sudoers.d/wodby; \
    \
    chown wodby:wodby /usr/share/nginx/html/50x.html; \
    \
    apk del --purge .nginx-build-deps .libmodsecurity-build-deps; \
    rm -rf \
        /tmp/* \
        /usr/local/modsecurity \
        /var/cache/apk/* ;

USER wodby

COPY bin /usr/local/bin
COPY templates /etc/gotpl/
COPY docker-entrypoint.sh /

WORKDIR $APP_ROOT
EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["sudo", "nginx"]
