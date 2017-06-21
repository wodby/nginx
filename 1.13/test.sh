#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

name=$1
image=$2

cid="$(docker run -d --name "${name}" "${image}")"
trap "docker rm -vf $cid > /dev/null" EXIT

nginx() {
	docker run --rm -i --link "${name}":"nginx" "$image" "$@"
}

nginx make check-ready max_try=10 host="nginx"
nginx curl -s "nginx" | grep 'Welcome to nginx!'
