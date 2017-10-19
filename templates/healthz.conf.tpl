location ~ ^/\.healthz$ {
    {{ if not (getenv "NGINX_ENABLE_HEALTHZ_LOGS") }}
    access_log off;
    {{ end }}
    return 204;
}