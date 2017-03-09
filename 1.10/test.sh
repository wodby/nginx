#!/usr/bin/env bash

set -e

[[ ! -z ${DEBUG} ]] && set -x

export NGINX_HOST='nginx'

NAME="${1}"
IMAGE="${2}"

cid="$(
	docker run -d \
		--name "${NAME}" \
		"${IMAGE}"
)"
trap "docker rm -vf $cid > /dev/null" EXIT

nginx() {
	docker run --rm -i \
	    --link "${NAME}":"${NGINX_HOST}" \
	    "$IMAGE" \
	    "$@" \
	    host="${NGINX_HOST}"
}

nginx make check-ready
nginx curl -s "${NGINX_HOST}" | grep 'Welcome to nginx!'
