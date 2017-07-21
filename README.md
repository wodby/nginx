# Nginx Docker Container Images

[![Build Status](https://travis-ci.org/wodby/nginx.svg?branch=master)](https://travis-ci.org/wodby/nginx)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)
[![Wodby Slack](http://slack.wodby.com/badge.svg)](http://slack.wodby.com)

## Docker Images

Images are built via [Travis CI](https://travis-ci.org/wodby/nginx) and published on [Docker Hub](https://hub.docker.com/r/wodby/nginx). 

## Versions

| Nginx | Alpine Linux |
| ----- | ------------ |
| [1.13.3](https://github.com/wodby/nginx/tree/master/1.13/Dockerfile) | 3.6 |  
| [1.12.1](https://github.com/wodby/nginx/tree/master/1.12/Dockerfile) | 3.6 |  

## Environment Variables

| Variable | Default Value | Description |
| -------- | ------------- | ----------- |
| NGINX_BACKEND_HOST             |                       | |
| NGINX_BACKEND_PORT             | 9000                  | |
| NGINX_CLIENT_BODY_TIMEOUT      | 600                   | |
| NGINX_CLIENT_HEADER_TIMEOUT    | 600                   | |
| NGINX_CLIENT_MAX_BODY_SIZE     | 256M                  | |
| NGINX_CONF_INCLUDE             | conf.d/*.conf         | |
| NGINX_ENABLE_HEALTHZ_LOGS      |                       | |
| NGINX_ERROR_LOG_LEVEL          | error                 | |
| NGINX_FASTCGI_BUFFERS          | 16 32k                | |
| NGINX_FASTCGI_BUFFER_SIZE      | 32k                   | |
| NGINX_FASTCGI_INTERCEPT_ERRORS | on                    | |
| NGINX_FASTCGI_READ_TIMEOUT     | 900                   | |
| NGINX_GZIP                     | on                    | |
| NGINX_GZIP_BUFFERS             | 16 8k                 | |
| NGINX_GZIP_COMP_LEVEL          | 2                     | |
| NGINX_GZIP_DISABLE             | msie6                 | |
| NGINX_GZIP_HTTP_VERSION        | 1.1                   | |
| NGINX_GZIP_MIN_LENGTH          | 20                    | |
| NGINX_GZIP_PROXIED             | any                   | |
| NGINX_GZIP_VARY                | on                    | |
| NGINX_KEEPALIVE_REQUESTS       | 100                   | |
| NGINX_KEEPALIVE_TIMEOUT        | 60                    | |
| NGINX_MULTI_ACCEPT             | on                    | |
| NGINX_RESET_TIMEOUT_CONNECTION | off                   | |
| NGINX_SEND_TIMEOUT             | 600                   | |
| NGINX_SENDFILE                 | on                    | |
| NGINX_SERVER_NAME              | default               | |
| NGINX_SERVER_TOKENS            | off                   | |
| NGINX_TCP_NODELAY              | on                    | |
| NGINX_TCP_NOPUSH               | on                    | |
| NGINX_UPLOAD_PROGRESS          | uploads 1m            | |
| NGINX_WORKER_CONNECTIONS       | 1024                  | |
| NGINX_WORKER_PROCESSES         | auto                  | |

## Installed Nginx Modules

* [1.13](https://raw.githubusercontent.com/wodby/nginx/master/1.13/tests/nginx_modules)
* [1.12](https://raw.githubusercontent.com/wodby/nginx/master/1.12/tests/nginx_modules)

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
