user                                    nginx;
daemon                                  off;
worker_processes                        {{ getenv "NGINX_WORKER_PROCESSES" "auto" }};
error_log                               /proc/self/fd/2 {{ getenv "NGINX_ERROR_LOG_LEVEL" "error" }};

events {
    worker_connections                  {{ getenv "NGINX_WORKER_CONNECTIONS" "1024" }};
    multi_accept                        {{ getenv "NGINX_MULTI_ACCEPT" "on" }};
}

http {
    include                             /etc/nginx/mime.types;
    default_type                        application/octet-stream;
    fastcgi_buffers                     {{ getenv "NGINX_FASTCGI_BUFFERS" "16 32k" }};
    fastcgi_buffer_size                 {{ getenv "NGINX_FASTCGI_BUFFER_SIZE" "32k" }};
    fastcgi_intercept_errors            {{ getenv "NGINX_FASTCGI_INTERCEPT_ERRORS" "on" }};
    fastcgi_read_timeout                {{ getenv "NGINX_FASTCGI_READ_TIMEOUT" "900" }};
    include                             fastcgi_params;
    access_log                          /proc/self/fd/1;
    port_in_redirect                    off;
    send_timeout                        {{ getenv "NGINX_SEND_TIMEOUT" "600" }};
    sendfile                            {{ getenv "NGINX_SENDFILE" "on" }};
    client_body_timeout                 {{ getenv "NGINX_CLIENT_BODY_TIMEOUT" "600" }};
    client_header_timeout               {{ getenv "NGINX_CLIENT_HEADER_TIMEOUT" "600" }};
    client_max_body_size                {{ getenv "NGINX_CLIENT_MAX_BODY_SIZE" "256M" }};
    client_body_buffer_size             {{ getenv "NGINX_CLIENT_BODY_BUFFER_SIZE" "16K" }};
    client_header_buffer_size           {{ getenv "NGINX_CLIENT_HEADER_BUFFER_SIZE" "4K" }};
    large_client_header_buffers         {{ getenv "NGINX_LARGE_CLIENT_HEADER_BUFFERS" "8 16K" }};
    keepalive_timeout                   {{ getenv "NGINX_KEEPALIVE_TIMEOUT" "60" }};
    keepalive_requests                  {{ getenv "NGINX_KEEPALIVE_REQUESTS" "100" }};
    reset_timedout_connection           {{ getenv "NGINX_RESET_TIMEOUT_CONNECTION" "off" }};
    tcp_nodelay                         {{ getenv "NGINX_TCP_NODELAY" "on" }};
    tcp_nopush                          {{ getenv "NGINX_TCP_NOPUSH" "on" }};
    server_tokens                       {{ getenv "NGINX_SERVER_TOKENS" "off" }};
    upload_progress                     {{ getenv "NGINX_UPLOAD_PROGRESS" "uploads 1m" }};

    gzip                                {{ getenv "NGINX_GZIP" "on" }};
    gzip_buffers                        {{ getenv "NGINX_GZIP_BUFFERS" "16 8k" }};
    gzip_comp_level                     {{ getenv "NGINX_GZIP_COMP_LEVEL" "2" }};
    gzip_http_version                   {{ getenv "NGINX_GZIP_HTTP_VERSION" "1.1" }};
    gzip_min_length                     {{ getenv "NGINX_GZIP_MIN_LENGTH" "20" }};
    gzip_types                          text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript image/x-icon application/vnd.ms-fontobject font/opentype application/x-font-ttf;
    gzip_vary                           {{ getenv "NGINX_GZIP_VARY" "on" }};
    gzip_proxied                        {{ getenv "NGINX_GZIP_PROXIED" "any" }};
    gzip_disable                        {{ getenv "NGINX_GZIP_DISABLE" "msie6" }};

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

    {{ if getenv "NGINX_BACKEND_HOST" }}
    upstream backend {
        server {{ getenv "NGINX_BACKEND_HOST" }}:{{ getenv "NGINX_BACKEND_PORT" "9000" }};
    }
    {{ end }}

    include {{ getenv "NGINX_CONF_INCLUDE" "conf.d/*.conf" }};
}
