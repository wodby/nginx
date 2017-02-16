#!/usr/bin/env bash

set -ex

waitForNginx() {
    done=''

    for i in {30..0}; do
        if curl -s "${1}:${2}" &> /dev/null ; then
            done=1
            break
        fi
        echo 'Nginx start process in progress...'
        sleep 1
    done

    if [[ ! "${done}" ]]; then
        echo "Failed to start Nginx" >&2
        exit 1
    fi
}

checkNginxResponse() {
    curl -s "${1}:${2}" | grep -c 'Welcome to nginx!'
}

runTests() {
    host=localhost
    port=8080

    waitForNginx "${host}" "${port}"
    checkNginxResponse "${host}" "${port}"
}

runTests
