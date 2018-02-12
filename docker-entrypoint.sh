#!/usr/bin/env bash

set -e

if [[ -n "${DEBUG}" ]]; then
    set -x
fi

exec_tpl() {
    if [[ -f "/etc/gotpl/$1" ]]; then
        gotpl "/etc/gotpl/$1" > "$2"
    fi
}

init_ssh_client() {
    local ssh_dir=/home/wodby/.ssh

    exec_tpl "ssh_config.tpl" "${ssh_dir}/config"

    if [[ -n "${SSH_PRIVATE_KEY}" ]]; then
        exec_tpl "id_rsa.tpl" "${ssh_dir}/id_rsa"
        chmod -f 600 "${ssh_dir}/id_rsa"
        unset SSH_PRIVATE_KEY
    fi
}

init_git() {
    git config --global user.email "${GIT_USER_EMAIL}"
    git config --global user.name "${GIT_USER_NAME}"
}

process_templates() {
    exec_tpl 'vhost.conf.tpl' '/etc/nginx/conf.d/vhost.conf'
    exec_tpl 'healthz.conf.tpl' '/etc/nginx/healthz.conf'
    exec_tpl 'nginx.conf.tpl' '/etc/nginx/nginx.conf'
}

sudo fix-volumes-permissions.sh

init_git
init_ssh_client
process_templates

exec-init-scripts.sh

if [[ "${1}" == 'make' ]]; then
    exec "${@}" -f /usr/local/bin/actions.mk
else
    exec $@
fi
