location ~ ^/.healthz$ {
    access_log {{ getenv "NGINX_LOC_HEALTHZ_ACCESS_LOG" "off" }};
    return 200;
}