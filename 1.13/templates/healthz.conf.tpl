location ~ ^/\.healthz$ {
    {{ if getenv "NGINX_ENABLE_HEALTHZ_LOGS" }}{{ else }}
    access_log off;
    {{ end }}
    return 200;
}