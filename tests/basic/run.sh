#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

git_url=https://github.com/wodby/nginx.git

clean_exit() {
  docker compose down
}
trap clean_exit EXIT

docker compose up -d

run_action() {
    docker compose exec -T nginx make "${@:2}" -f /usr/local/bin/actions.mk
}

run_action check-ready max_try=10

docker compose exec -T nginx tests.sh
docker compose down

cid="$(docker run -d -e NGINX_HTTP2=1 --name "nginx" "${IMAGE}")"
trap "docker rm -vf $cid > /dev/null" EXIT

docker run --rm -i -e DEBUG=1 -e NGINX_HTTP2=1 --link "nginx":"nginx" "${IMAGE}" make check-ready host=nginx

# In a workspace the workers run as the checkout's owner, so a file only that
# owner can read is still served. Outside a workspace it is refused.
owner_only_file_status() {
    local name="nginx-workspace-$1"
    docker run -d --rm --name "${name}" -e WODBY_WORKSPACE="$1" "${IMAGE}" > /dev/null
    docker exec "${name}" sh -c 'umask 077; echo private > /var/www/html/owner-only.txt'
    docker exec "${name}" make check-ready max_try=10 -f /usr/local/bin/actions.mk > /dev/null
    docker exec "${name}" curl -s -o /dev/null -w '%{http_code}' localhost/owner-only.txt
    docker stop "${name}" > /dev/null
}

[[ "$(owner_only_file_status 0)" == 403 ]]
[[ "$(owner_only_file_status 1)" == 200 ]]
