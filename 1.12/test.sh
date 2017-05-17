#!/usr/bin/env bash

set -e

[[ ! -z "${DEBUG}" ]] && set -x

name=$1
image=$2

cid="$(docker run -d --name "${name}" "${image}")"
trap "docker rm -vf $cid > /dev/null" EXIT

nginx() {
	docker run --rm -i --link "${name}":"nginx" "$image" "$@" host="nginx"
}

nginx make check-ready wait_seconds=1 max_try=10
nginx curl -s "nginx" | grep 'Welcome to nginx!'
