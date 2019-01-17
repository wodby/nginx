#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

docker-compose up -d

docker-compose exec nginx make check-ready max_try=10 -f /usr/local/bin/actions.mk
docker-compose exec php sh -c 'echo "<?php echo '\''Hello World!'\'';" > /var/www/html/index.php'

echo -n "Checking php endpoint... "
docker-compose exec nginx curl "localhost" | grep -q "Hello World!"
echo "OK"

echo -n "Checking Geo IP detection... "
brooklyn_ip="161.185.160.93"

docker-compose exec php sh -c 'echo "<?php var_dump(\$_SERVER[\"CITY_NAME\"]);" > /var/www/html/index.php'
docker-compose exec nginx curl --header "X-Forwarded-For: ${brooklyn_ip}" localhost | grep -q "Brooklyn"

docker-compose exec php sh -c 'echo "<?php var_dump(\$_SERVER[\"COUNTRY_CODE\"]);" > /var/www/html/index.php'
docker-compose exec nginx curl --header "X-Forwarded-For: ${brooklyn_ip}" localhost | grep -q "US"

docker-compose exec php sh -c 'echo "<?php var_dump(\$_SERVER[\"COUNTRY_NAME\"]);" > /var/www/html/index.php'
docker-compose exec nginx curl --header "X-Forwarded-For: ${brooklyn_ip}" localhost | grep -q "United States"
echo "OK"

docker-compose down
