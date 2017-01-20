#!/usr/bin/env bash

set -ex

host=localhost
port=8888

make start -e ENV='-e DEBUG=1' PORTS="-p ${port}:80"
sleep 2
curl -s ${host}:${port} | grep 'Welcome to nginx!'
make stop rm

echo Ok
