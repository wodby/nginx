#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

git_url=git@bitbucket.org:wodby/php-git-test.git

docker-compose -f test/docker-compose.yml up -d

docker_exec() {
    docker-compose -f test/docker-compose.yml exec "${@}"
}

run_action() {
    docker_exec "${1}" make "${@:2}" -f /usr/local/bin/actions.mk
}

run_action nginx check-ready max_try=10

docker_exec nginx tests.sh

# Git actions
echo -n "Running git actions... "
run_action nginx git-clone url="${git_url}" branch=master
run_action nginx git-checkout target=develop
echo "OK"

docker-compose -f test/docker-compose.yml down