#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
  set -x
fi

function execTpl {
    if [[ -f "/etc/gotpl/$1" ]]; then
        gotpl "/etc/gotpl/$1" > "$2"
    fi
}

function execInitScripts {
    shopt -s nullglob
    for f in /docker-entrypoint-init.d/*.sh; do
        echo "$0: running $f"
        . "$f"
    done
    shopt -u nullglob
}

fixPermissions() {
    chown -f www-data:www-data "${HTML_DIR}"
}

execTpl 'nginx.conf.tpl' '/etc/nginx/nginx.conf'
execTpl 'fastcgi_params.tpl' '/etc/nginx/fastcgi_params'
execTpl 'default-vhost.conf.tpl' '/etc/nginx/conf.d/default-vhost.conf'

fixPermissions
execInitScripts

if [[ "${1}" == 'make' ]]; then
    su-exec www-data "${@}" -f /usr/local/bin/actions.mk
else
    exec $@
fi
