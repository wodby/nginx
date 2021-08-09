#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

echo "It works!" > /var/www/html/index.html

echo -n "Checking Nginx response... "
curl -s localhost | grep -q "It works!"
echo "OK"

echo -n "Checking Modsecurity XSS... "
curl -s "localhost?test=<script>alert(42)</script>" | grep -q "403 Forbidden"
echo "OK"

echo -n "Checking LFI .. "
curl -s "localhost?template=../../etc/passwd" | grep -q "403 Forbidden"
echo "OK"

#echo -n "Checking SQL Injection "
#curl -s "http://localhost/ar?id=' OR 1='1" | grep -q "403 Forbidden"
#echo "OK"

rm /var/www/html/index.html

echo -n "Checking custom log format override .."
grep "log_format" /etc/nginx/nginx.conf | grep -q "custom"
grep "log_format" /etc/nginx/nginx.conf | grep -q '$http_x_real_ip - $request - $status'
grep "access_log" /etc/nginx/nginx.conf | grep -q "custom"
echo "Ok"

echo -n "Checking Nginx version... "
2>&1 nginx -v | grep -q "nginx/${NGINX_VER}"
echo "OK"

2>&1 nginx -V | tr -- - '\n' | grep -E "_module|module=" | sed -E 's#ngx_|=dynamic|_module|module=/tmp/##g' | sed 's/[ \t]*$//' | sort > /tmp/nginx_modules

echo -n "Checking Nginx modules... "
if ! cmp -s /tmp/nginx_modules /home/wodby/nginx_modules; then
    echo "Error. Nginx modules are not identical."
    diff /tmp/nginx_modules /home/wodby/nginx_modules
    exit 1
fi

echo "OK"
