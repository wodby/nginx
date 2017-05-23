# Nginx docker container image

[![Build Status](https://travis-ci.org/wodby/nginx.svg?branch=master)](https://travis-ci.org/wodby/nginx)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)
[![Wodby Slack](http://slack.wodby.com/badge.svg)](http://slack.wodby.com)

## Supported tags and respective `Dockerfile` links

- [`1.13-2.2.0`, `1.13`, `latest` (*1.13/Dockerfile*)](https://github.com/wodby/nginx/tree/master/1.13/Dockerfile)
- [`1.12-2.2.0`, `1.12`, (*1.12/Dockerfile*)](https://github.com/wodby/nginx/tree/master/1.12/Dockerfile)
- [`1.10-2.2.0`, `1.10`, (*1.10/Dockerfile*)](https://github.com/wodby/nginx/tree/master/1.10/Dockerfile)

## Environment variables available for customization

| Environment Variable | Default Value | Description |
| -------------------- | ------------- | ----------- |
| NGINX_WORKER_PROCESSES         | auto            | |
| NGINX_ERROR_LOG                | /proc/self/fd/2 | |
| NGINX_ERROR_LOG_LEVEL          | error           | |
| NGINX_WORKER_CONNECTIONS       | 1024            | |
| NGINX_MULTI_ACCEPT             | on              | |
| NGINX_FASTCGI_BUFFERS          | 16 32k          | |
| NGINX_FASTCGI_BUFFER_SIZE      | 32k             | |
| NGINX_FASTCGI_INTERCEPT_ERRORS | on              | |
| NGINX_FASTCGI_READ_TIMEOUT     | 900             | |
| NGINX_ACCESS_LOG               | /proc/self/fd/2 | |
| NGINX_SEND_TIMEOUT             | 600             | |
| NGINX_SENDFILE                 | on              | |
| NGINX_CLIENT_BODY_TIMEOUT      | 600             | |
| NGINX_CLIENT_HEADER_TIMEOUT    | 600             | |
| NGINX_CLIENT_MAX_BODY_SIZE     | 256             | |
| NGINX_KEEPALIVE_TIMEOUT        | 60              | |
| NGINX_KEEPALIVE_REQUESTS       | 100             | |
| NGINX_RESET_TIMEOUT_CONNECTION | off             | |
| NGINX_TCP_NODELAY              | on              | |
| NGINX_TCP_NOPUSH               | on              | |
| NGINX_SERVER_TOKENS            | off             | |
| NGINX_UPLOAD_PROGRESS          | uploads 1m      | |
| NGINX_GZIP                     | on              | |
| NGINX_GZIP_BUFFERS             | 16 8k           | |
| NGINX_GZIP_COMP_LEVEL          | 2               | |
| NGINX_GZIP_HTTP_VERSION        | 1.1             | |
| NGINX_GZIP_MIN_LENGTH          | 20              | |
| NGINX_GZIP_VARY                | on              | |
| NGINX_GZIP_PROXIED             | any             | |
| NGINX_GZIP_DISABLE             | msie6           | |
| NGINX_SERVER_NAME              | default         | |
| NGINX_BACKEND_PORT             | 9000            | |
| NGINX_BACKEND_HOST             |                 | |

## Actions

Usage:
```
make COMMAND [params ...]

commands:
    check-ready [host=<nginx> max_try=<10> wait_seconds=<5>]
 
default params values:
    host localhost
    max_try 1
    wait_seconds 1
```

Examples:

```bash
# Wait for Nginx to start
docker exec -ti [ID] make check-ready max_try=10 wait_seconds=1 -f /usr/local/bin/actions.mk
```

You can skip -f option if you use run instead of exec.

## Using in production

Deploy Nginx to your own server via [![Wodby](https://www.google.com/s2/favicons?domain=wodby.com) Wodby](https://wodby.com).
