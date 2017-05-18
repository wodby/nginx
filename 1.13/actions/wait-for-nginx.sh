#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

started=0
host=$1
max_try=$2
wait_seconds=$3

for i in $(seq 1 "${max_try}"); do
    if curl -s "${host}" &> /dev/null; then
        started=1
        break
    fi
    echo 'Nginx is starting...'
    sleep "${wait_seconds}"
done

if [[ "${started}" -eq '0' ]]; then
    echo >&2 'Error. Nginx is unreachable.'
    exit 1
fi

echo 'Nginx has started!'
