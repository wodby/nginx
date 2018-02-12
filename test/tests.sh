#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

echo -n "Checking Nginx version... "
2>&1 nginx -v | grep -q "nginx/${NGINX_VER}"
echo "OK"

2>&1 nginx -V | tr -- - '\n' | grep _module > /tmp/nginx_modules
echo -n "Checking Nginx modules... "

if ! cmp -s /tmp/nginx_modules /home/wodby/nginx_modules; then
    echo "Error. Nginx modules are not identical."
    diff /tmp/nginx_modules /home/wodby/nginx_modules
    exit 1
fi

echo "OK"
