user                                    nginx;
daemon                                  off;
worker_processes                        {{ getenv "NGINX_WORKER_PROCESSES" "1" }};
error_log                               /proc/self/fd/2;

events {
    worker_connections                  {{ getenv "NGINX_WORKER_CONNECTIONS" "1024" }};
    multi_accept                        on;
}

http {
    include                             /etc/nginx/mime.types;
    default_type                        application/octet-stream;
    fastcgi_buffers                     {{ getenv "NGINX_" "8 16k" }};
    fastcgi_buffer_size                 {{ getenv "NGINX_" "32k" }};
    fastcgi_intercept_errors            on;
    fastcgi_read_timeout                {{ getenv "NGINX_" "900" }};
    include                             fastcgi_params;
    access_log                          /proc/self/fd/2;
    port_in_redirect                    off;
    send_timeout                        {{ getenv "NGINX_SEND_TIMEOUT" "600" }};
    sendfile                            {{ getenv "NGINX_SENDFILE" "on" }};
    client_body_timeout                 {{ getenv "NGINX_CLIENT_BODY_TIMEOUT" "600" }};
    client_header_timeout               {{ getenv "NGINX_CLIENT_HEADER_TIMEOUT" "600" }};
    client_max_body_size                {{ getenv "NGINX_CLIENT_MAX_BODY_SIZE" "256M" }};
    keepalive_timeout                   {{ getenv "NGINX_KEEPALIVE_TIMEOUT" "60" }};
    keepalive_requests                  {{ getenv "NGINX_KEEPALIVE_REQUESTS" "100" }};
    reset_timedout_connection           off;
    tcp_nodelay                         on;
    tcp_nopush                          on;
    server_tokens                       off;
    upload_progress uploads             1m;

    gzip                                {{ getenv "NGINX_GZIP" "on" }};
    gzip_buffers                        16 8k;
    gzip_comp_level                     2;
    gzip_http_version                   1.1;
    gzip_min_length                     10240;
    gzip_types                          text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript image/x-icon application/vnd.ms-fontobject font/opentype application/x-font-ttf;
    gzip_vary                           on;
    gzip_proxied                        any;
    gzip_disable                        msie6;

    add_header                          X-XSS-Protection '1; mode=block';
    add_header                          X-Frame-Options SAMEORIGIN;
    add_header                          X-Content-Type-Options nosniff;

    map $http_x_forwarded_proto $fastcgi_https {
        default $https;
        http '';
        https on;
    }

    map $uri $no_slash_uri {
        ~^/(?<no_slash>.*)$ $no_slash;
    }

    include conf.d/*.conf;
}
