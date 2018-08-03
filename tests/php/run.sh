#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

docker-compose up -d

docker-compose exec nginx make check-ready max_try=10 -f /usr/local/bin/actions.mk
docker-compose exec nginx sh -c 'echo "<?php echo '\''Hello World!'\'';" > /var/www/html/index.php'

echo -n "Checking php endpoint... "
docker-compose exec nginx curl "localhost" | grep -q "Hello World!"
echo "OK"

docker-compose down