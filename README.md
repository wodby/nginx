# Nginx Docker Container Images

[![Build Status](https://travis-ci.org/wodby/nginx.svg?branch=master)](https://travis-ci.org/wodby/nginx)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)
[![Docker Layers](https://images.microbadger.com/badges/image/wodby/nginx.svg)](https://microbadger.com/images/wodby/nginx)

* [Docker images](#docker-images)
* [Environment variables](#environment-variables)
* [Installed modules](#installed-modules)
* [Virtual hosts presets](#virtual-hosts-presets)
    * [HTML](#html)
    * [PHP](#php)
    * [Drupal](#drupal)
    * [WordPress](#wordpress)
    * [HTTP proxy (application server)](#http-proxy-application-server)
* [Customization](#customization)
* [Orchestration actions](#orchestration-actions)

## Docker Images

❗For better reliability we release images with stability tags (`wodby/nginx:1.15-X.X.X`) which correspond to [git tags](https://github.com/wodby/nginx/releases). We strongly recommend using images only with stability tags. 

Overview:

* All images are based on Alpine Linux
* Base image: [wodby/alpine](https://github.com/wodby/alpine)
* [Travis CI builds](https://travis-ci.org/wodby/nginx) 
* [Docker Hub](https://hub.docker.com/r/wodby/nginx)

Supported tags and respective `Dockerfile` links:

* `1.15`, `1`, `latest` [_(Dockerfile)_](https://github.com/wodby/nginx/tree/master/Dockerfile)
* `1.14` [_(Dockerfile)_](https://github.com/wodby/nginx/tree/master/Dockerfile)
* `1.13` [_(Dockerfile)_](https://github.com/wodby/nginx/tree/master/Dockerfile)

## Environment Variables

| Variable                                  | Default Value               | Description                      |
| ----------------------------------------- | --------------------------- | -----------                      |
| `NGINX_BACKEND_FAIL_TIMEOUT`              | `0`                         |                                  |
| `NGINX_BACKEND_HOST`                      |                             |                                  |
| `NGINX_BACKEND_PORT`                      | `8080`                      | Default value varies for presets |
| `NGINX_CLIENT_BODY_BUFFER_SIZE`           | `16k`                       |                                  |
| `NGINX_CLIENT_BODY_TIMEOUT`               | `60s`                       |                                  |
| `NGINX_CLIENT_HEADER_BUFFER_SIZE`         | `4k`                        |                                  |
| `NGINX_CLIENT_HEADER_TIMEOUT`             | `60s`                       |                                  |
| `NGINX_CLIENT_MAX_BODY_SIZE`              | `32m`                       |                                  |
| `NGINX_CONF_INCLUDE`                      | `conf.d/*.conf`             |                                  |
| `NGINX_DISABLE_CACHING`                   |                             |                                  |
| `NGINX_ERROR_LOG_LEVEL`                   | `error`                     |                                  |
| `NGINX_ERROR_PAGE_403`                    |                             |                                  |
| `NGINX_ERROR_PAGE_404`                    |                             |                                  |
| `NGINX_GZIP_BUFFERS`                      | `16 8k`                     |                                  |
| `NGINX_GZIP_COMP_LEVEL`                   | `1`                         |                                  |
| `NGINX_GZIP_DISABLE`                      | `msie6`                     |                                  |
| `NGINX_GZIP_HTTP_VERSION`                 | `1.1`                       |                                  |
| `NGINX_GZIP_MIN_LENGTH`                   | `20`                        |                                  |
| `NGINX_GZIP_PROXIED`                      | `any`                       |                                  |
| `NGINX_GZIP_VARY`                         | `on`                        |                                  |
| `NGINX_GZIP`                              | `on`                        |                                  |
| `NGINX_HTTP2`                             |                             |                                  |
| `NGINX_INDEX_FILE`                        | `index.html index.htm`      | Default value varies for presets |
| `NGINX_KEEPALIVE_REQUESTS`                | `100`                       |                                  |
| `NGINX_KEEPALIVE_TIMEOUT`                 | `75s`                       |                                  |
| `NGINX_LARGE_CLIENT_HEADER_BUFFERS`       | `8 16k`                     |                                  |
| `NGINX_LOG_FORMAT_OVERRIDE`               |                             |                                  |
| `NGINX_LOG_FORMAT_SHOW_REAL_IP`           |                             |                                  |
| `NGINX_MULTI_ACCEPT`                      | `on`                        |                                  |
| `NGINX_NO_DEFAULT_HEADERS`                |                             |                                  |
| `NGINX_PAGESPEED_ENABLE_FILTERS`          |                             |                                  |
| `NGINX_PAGESPEED_FILE_CACHE_PATH`         | `/var/cache/ngx_pagespeed/` |                                  |
| `NGINX_PAGESPEED_PRESERVE_URL_RELATIVITY` | `on`                        |                                  |
| `NGINX_PAGESPEED_REWRITE_LEVEL`           | `CoreFilters`               |                                  |
| `NGINX_PAGESPEED_STATIC_ASSET_PREFIX`     | `/pagespeed_static`         |                                  |
| `NGINX_PAGESPEED`                         | `unplugged`                 |                                  |
| `NGINX_RESET_TIMEDOUT_CONNECTION`         | `off`                       |                                  |
| `NGINX_SEND_TIMEOUT`                      | `60s`                       |                                  |
| `NGINX_SENDFILE`                          | `on`                        |                                  |
| `NGINX_SERVER_EXTRA_CONF_FILEPATH`        |                             |                                  |
| `NGINX_SERVER_ROOT`                       | `/var/www/html`             |                                  |
| `NGINX_SERVER_NAME`                       | `default`                   |                                  |
| `NGINX_SERVER_TOKENS`                     | `off`                       |                                  |
| `NGINX_STATIC_ACCESS_LOG`                 | `off`                       |                                  |
| `NGINX_STATIC_EXPIRES`                    | `7d`                        |                                  |
| `NGINX_STATIC_MP4_BUFFER_SIZE`            | `1M`                        |                                  |
| `NGINX_STATIC_MP4_MAX_BUFFER_SIZE`        | `5M`                        |                                  |
| `NGINX_STATIC_OPEN_FILE_CACHE_ERRORS`     | `on`                        |                                  |
| `NGINX_STATIC_OPEN_FILE_CACHE_MIN_USES`   | `2`                         |                                  |
| `NGINX_STATIC_OPEN_FILE_CACHE_VALID`      | `30s`                       |                                  |
| `NGINX_STATIC_OPEN_FILE_CACHE`            | `max=1000 inactive=20s`     |                                  |
| `NGINX_TCP_NODELAY`                       | `on`                        |                                  |
| `NGINX_TCP_NOPUSH`                        | `on`                        |                                  |
| `NGINX_UNDERSCORES_IN_HEADERS`            | `off`                       |                                  |
| `NGINX_UPLOAD_PROGRESS`                   | `uploads 1m`                |                                  |
| `NGINX_USER`                              | `nginx`                     |                                  |
| `NGINX_VHOST_PRESET`                      | `html`                      |                                  |
| `NGINX_WORKER_CONNECTIONS`                | `1024`                      |                                  |
| `NGINX_WORKER_PROCESSES`                  | `auto`                      |                                  |

Static files extension defined via the regex and can be overriden via the env var `NGINX_STATIC_EXT_REGEX`, default:
```
css|cur|js|jpe?g|gif|htc|ico|png|xml|otf|ttf|eot|woff|woff2|svg|mp4|svgz|ogg|ogv|pdf|pptx?|zip|tgz|gz|rar|bz2|doc|xls|exe|tar|mid|midi|wav|bmp|rtf
```

## Installed modules

The list of installed modules: https://github.com/wodby/nginx/blob/master/tests/basic/nginx_modules

Include pagespeed module [pre-built for Alpine](https://github.com/wodby/nginx-alpine-psol)

## Virtual hosts presets

By default will be used `html` virtual host preset, you can change it via env var `$NGINX_VHOST_PRESET`. The list of available presets below,   

### HTML

[Virtual host template](https://github.com/wodby/nginx/blob/master/templates/presets/html.conf.tmpl)

```
NGINX_VHOST_PRESET=html
```

### Drupal

Additional environment variables for customization:

| Variable                           | Default Value               | Description                   |
| ---------------------------------- | --------------------------- | -----------                   |
| `NGINX_DRUPAL_ALLOW_XML_ENDPOINTS` |                             |                               |
| `NGINX_DRUPAL_FILE_PROXY_URL`      |                             | e.g. `http://dev.example.com` |
| `NGINX_DRUPAL_HIDE_HEADERS`        |                             |                               |
| `NGINX_DRUPAL_TRACK_UPLOADS`       | `uploads 60s`               |                               |
| `NGINX_DRUPAL_XMLRPC_SERVER_NAME`  |                             | Drupal 6 only                 |

#### Drupal 8  

[virtual host template](https://github.com/wodby/nginx/blob/master/templates/presets/drupal8.conf.tmpl)
  
```
NGINX_VHOST_PRESET=drupal8
```

#### Drupal 7 

[Virtual host template](https://github.com/wodby/nginx/blob/master/templates/presets/drupal7.conf.tmpl)
  
```
NGINX_VHOST_PRESET=drupal7
```

#### Drupal 6

[Virtual host template](https://github.com/wodby/nginx/blob/master/templates/presets/drupal6.conf.tmpl)
  
```
NGINX_VHOST_PRESET=drupal6
```

### WordPress

[Virtual host template](https://github.com/wodby/nginx/blob/master/templates/presets/wordpress.conf.tmpl)
  
```
NGINX_VHOST_PRESET=wordpress
```

### PHP

[Virtual host template](https://github.com/wodby/nginx/blob/master/templates/presets/php.conf.tmpl)

```
NGINX_VHOST_PRESET=php
```

### HTTP proxy (application server)

[Virtual host template](https://github.com/wodby/nginx/blob/master/templates/presets/http-proxy.conf.tmpl)

```
NGINX_VHOST_PRESET=http-proxy
```

## Customization

* If you can't customize a config via environment variables, you can completely override include of the virtual host config by overriding `NGINX_CONF_INCLUDE`, it will be included in `nginx.conf`.
* If you want to keep virtual host config but need to add extra locations use `NGINX_SERVER_EXTRA_CONF_FILEPATH`, the specified file will be included at the end of virtual host config (`server` context)
* Could not find your preset? Contributions are welcome! 

## Orchestration actions

Usage:
```
make COMMAND [params ...]

commands:
    git-clone [url branch]
    git-checkout [target is_hash]
    check-ready [host max_try wait_seconds delay_seconds]
 
default params values:
    host localhost
    max_try 1
    wait_seconds 1
    delay_seconds 0
    is_hash 0
    branch ""    
```
