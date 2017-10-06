#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

function exec_tpl {
    if [[ -f "/etc/gotpl/$1" ]]; then
        gotpl "/etc/gotpl/$1" > "$2"
    fi
}

exec_tpl 'default-vhost.conf.tpl' '/etc/nginx/conf.d/default-vhost.conf'
exec_tpl 'healthz.conf.tpl' '/etc/nginx/healthz.conf'
exec_tpl 'nginx.conf.tpl' '/etc/nginx/nginx.conf'

exec-init-scripts.sh

if [[ "${1}" == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec $@
fi
