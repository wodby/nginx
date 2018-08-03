{{ if getenv "NGINX_APP_SERVER_HOST" }}
upstream app_server {
    server {{ getenv "NGINX_APP_SERVER_HOST" }}:{{ getenv "NGINX_APP_SERVER_PORT" "8080" }} fail_timeout={{ getenv "NGINX_APP_SERVER_FAIL_TIMEOUT" "0" }};
}
{{ end }}

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

{{ if getenv "NGINX_APP_SERVER_HOST" }}
        try_files $uri @app;
{{ else }}
        index {{ getenv "NGINX_INDEX_FILE" "index.html index.htm" }};
        try_files $uri $uri/ /{{ getenv "NGINX_INDEX_FILE" "index.html index.htm" }};
{{ end }}
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

{{ if getenv "NGINX_APP_SERVER_HOST" }}
    location @app {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://app_server;
    }
{{ end }}

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

{{ if getenv "NGINX_ERROR_PAGE_403" }};
    error_page 403 {{ getenv "NGINX_ERROR_PAGE_403" }};
{{ end }}

{{ if getenv "NGINX_ERROR_PAGE_404" }};
    error_page 404 {{ getenv "NGINX_ERROR_PAGE_404" }};
{{ end }}

    include pagespeed.conf;
    include healthz.conf;
}
