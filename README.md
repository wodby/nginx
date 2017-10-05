# Nginx Docker Container Images

[![Build Status](https://travis-ci.org/wodby/nginx.svg?branch=master)](https://travis-ci.org/wodby/nginx)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)
[![Wodby Slack](http://slack.wodby.com/badge.svg)](http://slack.wodby.com)

## Docker Images

* All images are based on Alpine Linux
* Base image: [wodby/alpine](https://github.com/wodby/alpine)
* [Travis CI builds](https://travis-ci.org/wodby/nginx) 
* [Docker Hub](https://hub.docker.com/r/wodby/nginx)

## Versions

| Nginx (Dockerfile)                                              | Alpine Linux |
| --------------------------------------------------------------- | ------------ |
| [1.13.5](https://github.com/wodby/nginx/tree/master/Dockerfile) | 3.6          |
| [1.12.1](https://github.com/wodby/nginx/tree/master/Dockerfile) | 3.6          |

## Environment Variables

| Variable                          | Default Value | Description |
| --------------------------------- | ------------- | ----------- |
| NGINX_CLIENT_BODY_BUFFER_SIZE     | 16k           |             |
| NGINX_CLIENT_BODY_TIMEOUT         | 60s           |             |
| NGINX_CLIENT_HEADER_BUFFER_SIZE   | 4k            |             |
| NGINX_CLIENT_HEADER_TIMEOUT       | 60s           |             |
| NGINX_CLIENT_MAX_BODY_SIZE        | 32m           |             |
| NGINX_CONF_INCLUDE                | conf.d/*.conf |             |
| NGINX_ENABLE_HEALTHZ_LOGS         |               |             |
| NGINX_ERROR_LOG_LEVEL             | error         |             |
| NGINX_GZIP                        | on            |             |
| NGINX_GZIP_BUFFERS                | 16 8k         |             |
| NGINX_GZIP_COMP_LEVEL             | 1             |             |
| NGINX_GZIP_DISABLE                | msie6         |             |
| NGINX_GZIP_HTTP_VERSION           | 1.1           |             |
| NGINX_GZIP_MIN_LENGTH             | 20            |             |
| NGINX_GZIP_PROXIED                | any           |             |
| NGINX_GZIP_VARY                   | on            |             |
| NGINX_KEEPALIVE_REQUESTS          | 100           |             |
| NGINX_KEEPALIVE_TIMEOUT           | 75s           |             |
| NGINX_LARGE_CLIENT_HEADER_BUFFERS | 8 16k         |             |
| NGINX_MULTI_ACCEPT                | on            |             |
| NGINX_RESET_TIMEDOUT_CONNECTION   | off           |             |
| NGINX_SEND_TIMEOUT                | 60s           |             |
| NGINX_SENDFILE                    | on            |             |
| NGINX_SERVER_TOKENS               | off           |             |
| NGINX_TCP_NODELAY                 | on            |             |
| NGINX_TCP_NOPUSH                  | on            |             |
| NGINX_UPLOAD_PROGRESS             | uploads 1m    |             |
| NGINX_USER                        | nginx         |             |
| NGINX_WORKER_CONNECTIONS          | 1024          |             |
| NGINX_WORKER_PROCESSES            | auto          |             |

## Installed Nginx Modules

* [1.13](https://raw.githubusercontent.com/wodby/nginx/master/tests/nginx_modules)
* [1.12](https://raw.githubusercontent.com/wodby/nginx/master/tests/nginx_modules)

## Actions

Usage:
```
make COMMAND [params ...]

commands:
    check-ready [host max_try wait_seconds delay_seconds]
 
default params values:
    host localhost
    max_try 1
    wait_seconds 1
    delay_seconds 0
```
