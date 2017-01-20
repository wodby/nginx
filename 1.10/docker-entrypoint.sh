#!/usr/bin/env bash

set -e

if [[ -n $DEBUG ]]; then
  set -x
fi

gotpl /etc/gotpl/nginx.conf.tpl > /etc/nginx/nginx.conf
gotpl /etc/gotpl/fastcgi_params.tpl > /etc/nginx/fastcgi_params
gotpl /etc/gotpl/default-vhost.conf.tpl > /etc/nginx/conf.d/default-vhost.conf

chown -R nginx:nginx /etc/nginx/

shopt -s nullglob
for f in /docker-entrypoint-init.d/*.sh; do
    echo "$0: running $f"
    . "$f"
done
shopt -u nullglob

exec "$@"
