{{ pagespeed := (getenv "NGINX_PAGESPEED") }}
{{ if (eq $pagespeed "on") }}
location ~ "\.pagespeed\.([a-z]\.)?[a-z]{2}\.[^.]{10}\.[^.]+" {
    add_header "" "";
}

location ~ "^/pagespeed_static/" { }
location ~ "^/ngx_pagespeed_beacon$" { }
{{ end }}
