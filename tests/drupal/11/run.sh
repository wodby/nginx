#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

nginx_exec() {
    docker compose exec -T nginx "${@}"
}

drupal_exec() {
    docker compose exec -T drupal "${@}"
}

clean_exit() {
  docker compose down -v
}
trap clean_exit EXIT

docker compose up -d

nginx_exec make check-ready -f /usr/local/bin/actions.mk

drupal_exec mkdir -p web/sites/abc/modules/contrib/test
drupal_exec mkdir -p web/modules/contrib/test
drupal_exec touch web/sites/abc/modules/contrib/test/CHANGELOG.md
drupal_exec touch web/sites/abc/modules/contrib/test/README.md
drupal_exec touch web/sites/abc/modules/contrib/test/INSTALL.md
drupal_exec touch web/modules/contrib/test/CHANGELOG.md
drupal_exec touch web/modules/contrib/test/README.md
drupal_exec touch web/modules/contrib/test/INSTALL.md

# TODO: check endpoints of installed Drupal

echo "Checking Drupal endpoints"
echo -n "Checking / page... "
nginx_exec curl -s -S -I "localhost" | grep '302 Found'
echo -n "authorize.php...   "
nginx_exec curl -s -S -I "localhost/core/authorize.php" | grep '500 Service unavailable'
echo -n "install.php...     "
nginx_exec curl -s -S -I "localhost/core/install.php" | grep '200 OK'
echo -n "cron...            "
nginx_exec curl -s -S -I "localhost/cron" | grep '302 Found'
echo -n "index.php...       "
nginx_exec curl -s -S -I "localhost/index.php" | grep '302 Found'
echo -n "index.php/node...       "
nginx_exec curl -s -S -I "localhost/index.php/node" | grep '302 Found'
echo -n "update.php...      "
nginx_exec curl -s -S -I "localhost/update.php" | grep '302 Found'
echo -n ".htaccess...       "
nginx_exec curl -s -S -I "localhost/.htaccess" | grep '403 Forbidden'
echo -n "favicon.ico...     "
nginx_exec curl -s -S -I "localhost/favicon.ico" | grep '200 OK'
echo -n "robots.txt...      "
nginx_exec curl -s -S -I "localhost/robots.txt" | grep '200 OK'
echo -n "humans.txt...      "
nginx_exec curl -s -S -I "localhost/humans.txt" | grep '302 Found'
echo -n "ads.txt...      "
nginx_exec curl -s -S -I "localhost/ads.txt" | grep '302 Found'
echo -n "drupal.js...       "
nginx_exec curl -s -S -I "localhost/core/misc/drupal.js" | grep '200 OK'
echo -n "druplicon.png...   "
nginx_exec curl -s -S -I "localhost/core/misc/druplicon.png" | grep '200 OK'
echo -n "Checking composer.json"
nginx_exec curl -s -S -I "localhost/composer.json" | grep '404 Not Found'
echo -n "Checking package.json"
nginx_exec curl -s -S -I "localhost/core/package.json" | grep '404 Not Found'
echo -n "Checking web.config"
nginx_exec curl -s -S -I "localhost/web.config" | grep '404 Not Found'

echo -n "Checking non existing php endpoint... "
nginx_exec curl -s -S -I "localhost/non-existing.php" | grep '404 Not Found'
echo -n "Checking user-defined internal temporal redirect... "
nginx_exec curl -s -S -I "localhost/redirect-internal-temporal" | grep '302 Moved Temporarily'
echo -n "Checking user-defined internal permanent redirect... "
nginx_exec curl -s -S -I "localhost/redirect-internal-permanent" | grep '301 Moved Permanently'
echo -n "Checking user-defined external redirect... "
nginx_exec curl -s -S -I "localhost/redirect-external" | grep '302 Moved Temporarily'
echo -n "Checking CSP header...   "
nginx_exec curl -s -S -I "localhost" | grep "frame-ancestors 'self'"

echo -n "Checking modules md files...   "
nginx_exec curl -s -S -I "localhost/modules/contrib/test/README.md" | grep "404 Not Found"
nginx_exec curl -s -S -I "localhost/modules/contrib/test/INSTALL.md" | grep "404 Not Found"
nginx_exec curl -s -S -I "localhost/modules/contrib/test/CHANGELOG.md" | grep "404 Not Found"

nginx_exec curl -s -S -I "localhost/sites/abc/modules/contrib/test/README.md" | grep "404 Not Found"
nginx_exec curl -s -S -I "localhost/sites/abc/modules/contrib/test/INSTALL.md" | grep "404 Not Found"
nginx_exec curl -s -S -I "localhost/sites/abc/modules/contrib/test/CHANGELOG.md" | grep "404 Not Found"
