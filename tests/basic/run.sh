#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

git_url=https://github.com/wodby/nginx.git

clean_exit() {
  docker-compose down
}
trap clean_exit EXIT

docker-compose up -d

run_action() {
    docker-compose exec -T nginx make "${@:2}" -f /usr/local/bin/actions.mk
}

run_action check-ready max_try=10

docker-compose exec -T nginx tests.sh
docker-compose down

cid="$(docker run -d -e NGINX_HTTP2=1 --name "nginx" "${IMAGE}")"
trap "docker rm -vf $cid > /dev/null" EXIT

docker run --rm -i -e DEBUG=1 -e NGINX_HTTP2=1 --link "nginx":"nginx" "${IMAGE}" make check-ready host=nginx
