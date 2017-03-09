#!/usr/bin/env bash

set -e

[[ ! -z ${DEBUG} ]] && set -x

started=0
HOST="${1}"
MAX_TRY="${2}"
WAIT_SECONDS="${3}"

for i in $(seq 1 "${MAX_TRY}"); do
    if curl -s "${HOST}" &> /dev/null; then
        started=1
        break
    fi
    echo 'Nginx is starting...'
    sleep "${WAIT_SECONDS}"
done

if [[ "$started" -eq '0' ]]; then
    echo >&2 'Error. Nginx is unreachable.'
    exit 1
fi

echo 'Nginx has started!'
