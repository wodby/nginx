#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

name=$1
image=$2

cid="$(docker run -d --name "${name}" "${image}")"
trap "docker rm -vf $cid > /dev/null" EXIT

docker run --rm -i -v ${PWD}/tests:/tests --link "${name}":"nginx" "$image" su-exec www-data /tests/tests.sh