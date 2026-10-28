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

echo "Checking file proxy"
drupal_exec mkdir -p web/sites/default/files/private
drupal_exec sh -c 'echo public > web/sites/default/files/existing.txt'
drupal_exec sh -c 'echo secret > web/sites/default/files/private/secret.txt'
echo -n "existing public file...      "
nginx_exec curl -s -S -I "localhost/sites/default/files/existing.txt" | grep '200 OK'
echo -n "missing public file...       "
nginx_exec curl -s -S -I "localhost/sites/default/files/missing.pdf" | grep 'Location: http://files.example.com/sites/default/files/missing.pdf'
echo -n "missing CSS aggregate...     "
nginx_exec curl -s -S -I "localhost/sites/default/files/optimized/css/css_missing.css?delta=0" | grep '302 Found'
echo -n "missing JS aggregate...      "
nginx_exec curl -s -S -I "localhost/sites/default/files/optimized/js/js_missing.js?delta=0" | grep '302 Found'
echo -n "private file...              "
nginx_exec curl -s -S -I "localhost/sites/default/files/private/secret.txt" | grep '404 Not Found'

# Image styles need an installed Drupal, so these run last.
echo "Checking image styles with file proxy"
drupal_exec sh -c 'cd web && ../vendor/bin/dr install standard' > /dev/null
drupal_exec cp web/core/misc/druplicon.png web/sites/default/files/local.png
drupal_exec chown -R www-data:www-data web/sites/default
docker compose cp ../image-style-url.php drupal:/opt/drupal/image-style-url.php
local_style=$(drupal_exec php /opt/drupal/image-style-url.php thumbnail public://local.png)
missing_style=$(drupal_exec php /opt/drupal/image-style-url.php thumbnail public://missing.png)
echo -n "local source, built by Drupal...   "
drupal_exec test ! -e "web${local_style%%\?*}"
nginx_exec curl -s -S -I "localhost${local_style}" | grep '200 OK'
drupal_exec test -f "web${local_style%%\?*}"
echo -n "existing image style...            "
nginx_exec curl -s -S -I "localhost${local_style}" | grep '200 OK'
echo -n "missing source...                  "
nginx_exec curl -s -S -I "localhost${missing_style}" | grep -F "Location: http://files.example.com${missing_style}"
echo -n "unknown image style...             "
nginx_exec curl -s -S -I "localhost/sites/default/files/styles/unknown/public/local.png" | grep 'Location: http://files.example.com/sites/default/files/styles/unknown/public/local.png'
