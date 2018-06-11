#!/usr/bin/env bash

set -e

if [[ "${TRAVIS_PULL_REQUEST}" == "false" && ("${TRAVIS_BRANCH}" == "master"  || -n "${TRAVIS_TAG}") ]]; then
    docker login -u "${DOCKER_USERNAME}" -p "${DOCKER_PASSWORD}"

    if [[ -n "${TRAVIS_TAG}" ]]; then
        export STABILITY_TAG="${TRAVIS_TAG}"
    fi

    IFS=',' read -ra tags <<< "${TAGS}"

    for tag in "${tags[@]}"; do
        if [[ "${TAG}" == "${LATEST_TAG}" ]]; then
            make release TAG="latest";
        else
            make release TAG="${tag}";
        fi
    done
fi
