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
docker-compose exec -T matomo make init -f /usr/local/bin/actions.mk

echo -n "Checking homepage endpoint... "
check_endpoint "" "200 OK"

echo -n "Checking config php... "
check_endpoint "config/config.ini.php" "403 Forbidden"

echo -n "Checking index page... "
check_endpoint "index.php" "200 OK"

echo -n "Checking matomo page... "
check_endpoint "matomo.php" "200 OK"

echo -n "Checking php file in core directory... "
check_endpoint "core/Twig.php" "403 Forbidden"

echo -n "Checking file from lang directory... "
check_endpoint "lang/en.json" "403 Forbidden"

echo -n "Checking tmp dir... "
check_endpoint "tmp/cache/test" "403 Forbidden"

echo -n "Checking md file... "
check_endpoint "README.md" "200 OK"

echo -n "Checking file from misc... "
check_endpoint "misc/log-analytics/README.md" "403 Forbidden"

echo -n "Checking node_modules directory... "
check_endpoint "node_modules/jquery/README.md" "403 Forbidden"

echo -n "Checking libs directory... "
check_endpoint "libs/README.md" "403 Forbidden"

echo -n "Checking plugins directory... "
check_endpoint "plugins/SEO/templates/getRank.twig" "403 Forbidden"

echo -n "Checking vendor directory... "
check_endpoint "vendor/twig/twig/README.rst" "403 Forbidden"

echo -n "Checking favicon endpoint... "
check_endpoint "favicon.ico" "200 OK"

echo -n "Checking non-existing php endpoint... "
check_endpoint "non-existing.php" "403 Forbidden"
