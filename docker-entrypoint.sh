#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

_gotpl() {
    if [[ -f "/etc/gotpl/$1" ]]; then
        gotpl "/etc/gotpl/$1" > "$2"
    fi
}

process_templates() {
    _gotpl 'nginx.conf.tmpl' '/etc/nginx/nginx.conf'
    _gotpl 'vhost.conf.tmpl' '/etc/nginx/conf.d/vhost.conf'

    _gotpl 'includes/defaults.conf.tmpl' '/etc/nginx/defaults.conf'
    _gotpl 'includes/fastcgi.conf.tmpl' '/etc/nginx/fastcgi.conf'

    _gotpl "presets/${NGINX_VHOST_PRESET}.conf.tmpl" '/etc/nginx/preset.conf'

    if [[ "${NGINX_VHOST_PRESET}" =~ ^drupal8|drupal7|drupal6|wordpress|php$ ]]; then
        _gotpl 'includes/upstream.php.conf.tmpl' '/etc/nginx/upstream.conf'
    elif [[ "${NGINX_VHOST_PRESET}" == "http-proxy" ]]; then
        _gotpl 'includes/upstream.http-proxy.conf.tmpl' '/etc/nginx/upstream.conf'
    fi
}

sudo init_volumes

process_templates
exec_init_scripts

if [[ "${1}" == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec $@
fi
