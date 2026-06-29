#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

clean_exit() {
  docker compose down
}
trap clean_exit EXIT

docker compose up -d

docker compose exec -T nginx make check-ready max_try=10 -f /usr/local/bin/actions.mk
docker compose exec -T php sh -c 'echo "<?php echo '\''Hello World!'\'';" > /var/www/html/index.php'

echo -n "Checking php endpoint... "
php_endpoint_ready=0
php_endpoint_response=
for i in $(seq 1 10); do
    php_endpoint_response="$(docker compose exec -T nginx curl -s -S -i "localhost" 2>&1 || true)"
    if grep -q "Hello World!" <<< "${php_endpoint_response}"; then
        php_endpoint_ready=1
        break
    fi
    sleep 1
done

if [[ "${php_endpoint_ready}" -eq 1 ]]; then
    echo "OK"
else
    echo "FAIL"
    echo "${php_endpoint_response}"
    docker compose logs nginx php
    exit 1
fi
