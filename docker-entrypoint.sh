#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

exec_tpl() {
    if [[ -f "/etc/gotpl/$1" ]]; then
        gotpl "/etc/gotpl/$1" > "$2"
    fi
}

process_templates() {
    exec_tpl 'vhost.conf.tpl' '/etc/nginx/conf.d/vhost.conf'
    exec_tpl 'healthz.conf.tpl' '/etc/nginx/healthz.conf'
    exec_tpl 'nginx.conf.tpl' '/etc/nginx/nginx.conf'
}

sudo init_volumes

process_templates

exec_init_scripts

if [[ "${1}" == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec $@
fi
