#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

check_endpoint() {
    docker-compose exec -T nginx curl -s -S -I "localhost/${1}" | grep -q "${2}"
    echo "OK"
}

clean_exit() {
  docker-compose down
}
trap clean_exit EXIT

docker-compose up -d

docker-compose exec -T nginx make check-ready -f /usr/local/bin/actions.mk
docker-compose exec -T wordpress make init -f /usr/local/bin/actions.mk

echo -n "Checking homepage endpoint... "
check_endpoint "" "302 Found"

echo -n "Checking setup page endpoint... "
check_endpoint "wp-admin/setup-config.php" "200 OK"

echo -n "Checking static endpoint (webp)... "
check_endpoint "wp-content/themes/twentytwentyfour/assets/images/windows.webp" "200 OK"

echo -n "Checking static endpoint (woff2)... "
check_endpoint "wp-content/themes/twentytwentyfour/assets/fonts/jost/Jost-VariableFont_wght.woff2" "200 OK"

echo -n "Checking static endpoint (css)... "
check_endpoint "wp-content/themes/twentytwentyfour/assets/css/button-outline.css" "200 OK"

echo -n "Checking readme.html endpoint... "
check_endpoint "readme.html" "404 Not Found"

echo -n "Checking static endpoint (txt)... "
check_endpoint "license.txt" "404 Not Found"

echo -n "Checking .htaccess endpoint... "
check_endpoint ".htaccess" "403 Forbidden"

echo -n "Checking favicon endpoint... "
check_endpoint "favicon.ico" "200 OK"

echo -n "Checking non-existing php endpoint... "
check_endpoint "non-existing.php" "404 Not Found"

echo -n "Check CSP header...   "
check_endpoint "" "frame-ancestors 'self'"
