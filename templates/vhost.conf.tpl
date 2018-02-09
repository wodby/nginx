server {
    listen       80;
    server_name  {{ getenv "NGINX_SERVER_NAME" "default" }};

    location / {
        root {{ getenv "NGINX_SERVER_ROOT" "/var/www/html" }};
        index {{ getenv "NGINX_INDEX_FILE" "index.html index.htm" }};
    }

    include healthz.conf;
}
