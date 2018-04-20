server {
    listen       80 default_server{{ if getenv "NGINX_HTTP2" }} http2{{ end }};
    server_name  {{ getenv "NGINX_SERVER_NAME" "default" }};

    location / {
        root {{ getenv "NGINX_SERVER_ROOT" "/var/www/html" }};

        {{ if getenv "NGINX_DISABLE_CACHING" }}
        expires -1;
        add_header Pragma "no-cache";
        add_header Cache-Control "no-store, no-cache, must-revalicate, post-check=0 pre-check=0";
        {{ end }}

        index {{ getenv "NGINX_INDEX_FILE" "index.html index.htm" }};
        try_files $uri $uri/ /{{ getenv "NGINX_INDEX_FILE" "index.html index.htm" }};
    }

    location ~* ^.+\.(?:css|cur|js|jpe?g|gif|htc|ico|png|xml|otf|ttf|eot|woff|woff2|svg|svgz)$ {
        root {{ getenv "NGINX_SERVER_ROOT" "/var/www/html" }};
        access_log off;
        expires 7d;
        add_header Pragma "cache";
        add_header Cache-Control "public";
        tcp_nodelay off;
        open_file_cache max=1000 inactive=20s;
        open_file_cache_valid 30s;
        open_file_cache_min_uses 2;
        open_file_cache_errors on;

        location ~* ^.+\.svgz$ {
            gzip off;
            add_header Content-Encoding gzip;
        }
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    include healthz.conf;
}
