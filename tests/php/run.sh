#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

clean_exit() {
  docker-compose down
}
trap clean_exit EXIT

docker-compose up -d

docker-compose exec -T nginx make check-ready max_try=10 -f /usr/local/bin/actions.mk
docker-compose exec -T php sh -c 'echo "<?php echo '\''Hello World!'\'';" > /var/www/html/index.php'

echo -n "Checking php endpoint... "
docker-compose exec -T nginx curl -s -S "localhost" | grep -q "Hello World!"
echo "OK"
