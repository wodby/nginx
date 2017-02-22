# Generic Nginx docker container

[![Build Status](https://travis-ci.org/wodby/nginx.svg?branch=master)](https://travis-ci.org/wodby/nginx)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)

## Supported tags and respective `Dockerfile` links

- [`1.10`, `latest` (*1.10/Dockerfile*)](https://github.com/wodby/nginx/tree/master/1.10/Dockerfile)

## Environment Variables Available for Customization

| Environment Variable | Type | Default Value | Description |
| -------------------- | -----| ------------- | ----------- |
| NGINX_WORKER_PROCESSES                | Int    | 1               | |
| NGINX_ERROR_LOG                       | String | /proc/self/fd/2 | |
| NGINX_ERROR_LOG_LEVEL                 | String | error           | |
| NGINX_WORKER_CONNECTIONS              | Int    | 1024            | |
| NGINX_MULTI_ACCEPT                    | String | on              | |
| NGINX_FASTCGI_BUFFERS                 | String | 8 16k           | |
| NGINX_FASTCGI_BUFFER_SIZE             | String | 32k             | |
| NGINX_FASTCGI_INTERCEPT_ERRORS        | String | on              | |
| NGINX_FASTCGI_READ_TIMEOUT            | Int    | 900             | |
| NGINX_ACCESS_LOG                      | String | /proc/self/fd/2 | |
| NGINX_SEND_TIMEOUT                    | Int    | 600             | |
| NGINX_SENDFILE                        | String | on              | |
| NGINX_CLIENT_BODY_TIMEOUT             | Int    | 600             | |
| NGINX_CLIENT_HEADER_TIMEOUT           | Int    | 600             | |
| NGINX_CLIENT_MAX_BODY_SIZE            | Int    | 256             | |
| NGINX_KEEPALIVE_TIMEOUT               | Int    | 60              | |
| NGINX_KEEPALIVE_REQUESTS              | Int    | 100             | |
| NGINX_RESET_TIMEOUT_CONNECTION        | String | off             | |
| NGINX_TCP_NODELAY                     | String | on              | |
| NGINX_TCP_NOPUSH                      | String | on              | |
| NGINX_SERVER_TOKENS                   | String | off             | |
| NGINX_UPLOAD_PROGRESS                 | String | uploads 1m      | |
| NGINX_GZIP                            | String | on              | |
| NGINX_GZIP_BUFFERS                    | String | 16 8k           | |
| NGINX_GZIP_COMP_LEVEL                 | Int    | 2               | |
| NGINX_GZIP_HTTP_VERSION               | String | 1.1             | |
| NGINX_GZIP_MIN_LENGTH                 | Int    | 20              | |
| NGINX_GZIP_VARY                       | String | on              | |
| NGINX_GZIP_PROXIED                    | String | any             | |
| NGINX_GZIP_DISABLE                    | String | msie6           | |
| NGINX_SERVER_NAME                     | String | default         | |
| NGINX_BACKEND_PORT                    | Int    | 9000            | |
| NGINX_BACKEND_HOST                    | String |                 | |
