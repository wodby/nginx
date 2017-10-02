#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

function exec_tpl {
    gotpl "/etc/gotpl/$1" > "$2"
}

function exec_init_scripts {
    shopt -s nullglob
    for f in /docker-entrypoint-init.d/*.sh; do
        echo "$0: running $f"
        . "$f"
    done
    shopt -u nullglob
}

sudo fix-permissions.sh nginx nginx "${HTML_DIR}"

if [[ -f "/etc/gotpl/default-vhost.conf.tpl" ]]; then
    exec_tpl 'default-vhost.conf.tpl' '/etc/nginx/conf.d/default-vhost.conf'
fi

exec_tpl 'healthz.conf.tpl' '/etc/nginx/healthz.conf'
exec_tpl 'nginx.conf.tpl' '/etc/nginx/nginx.conf'

exec_init_scripts

if [[ "${1}" == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec $@
fi
