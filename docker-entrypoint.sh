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

sudo init_volumes

_gotpl 'vhost.conf.tpl' '/etc/nginx/conf.d/vhost.conf'
_gotpl 'pagespeed.conf.tpl' '/etc/nginx/pagespeed.conf'
_gotpl 'healthz.conf.tpl' '/etc/nginx/healthz.conf'
_gotpl 'nginx.conf.tpl' '/etc/nginx/nginx.conf'

exec_init_scripts

if [[ "${1}" == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec $@
fi
