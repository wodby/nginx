#!/usr/bin/env bash

set -ex

host=localhost
port=8888

make start -e ENV='-e DEBUG=1' PORTS="-p ${port}:80"

for i in {30..0}; do
    if curl -s "${host}:${port}" &> /dev/null ; then
        break
    fi
    echo 'Nginx start process in progress...'
    sleep 1
done

curl -s ${host}:${port} | grep 'Welcome to nginx!'

make stop rm
