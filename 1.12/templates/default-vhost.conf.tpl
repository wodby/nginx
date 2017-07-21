server {
    listen       80;
    server_name  {{ getenv "NGINX_SERVER_NAME" "default" }};

    location / {
        root   html;
        index  index.html index.htm;
    }

    include healthz.conf;
}
