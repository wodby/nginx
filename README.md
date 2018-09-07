# Nginx Docker Container Images

[![Build Status](https://travis-ci.org/wodby/nginx.svg?branch=master)](https://travis-ci.org/wodby/nginx)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)
[![Docker Layers](https://images.microbadger.com/badges/image/wodby/nginx.svg)](https://microbadger.com/images/wodby/nginx)

* [Docker images](#docker-images)
* [Environment variables](#environment-variables)
* [Modules](#modules)
* [Virtual hosts presets](#virtual-hosts-presets)
    * [HTML](#html)
    * [HTTP proxy (application server)](#http-proxy-application-server)
    * [PHP-based (FastCGI)](#php-based-fastcgi)
        * [PHP](#php)
        * [WordPress](#wordpress)
        * [Drupal](#drupal)
    * [Custom preset](#custom-preset)
    * [No preset](#no-preset)
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

| Variable                                  | Default Value               | Description |
| ----------------------------------------- | --------------------------- | ----------- |
| `NGINX_ALLOW_ACCESS_HIDDEN_FILES`         |                             |             |
| `NGINX_BACKEND_FAIL_TIMEOUT`              | `0`                         |             |
| `NGINX_BACKEND_HOST`                      |                             |             |
| `NGINX_BACKEND_PORT`                      |                             |             |
| `NGINX_CLIENT_BODY_BUFFER_SIZE`           | `16k`                       |             |
| `NGINX_CLIENT_BODY_TIMEOUT`               | `60s`                       |             |
| `NGINX_CLIENT_HEADER_BUFFER_SIZE`         | `4k`                        |             |
| `NGINX_CLIENT_HEADER_TIMEOUT`             | `60s`                       |             |
| `NGINX_CLIENT_MAX_BODY_SIZE`              | `32m`                       |             |
| `NGINX_CONF_INCLUDE`                      | `conf.d/*.conf`             |             |
| `NGINX_DISABLE_CACHING`                   |                             |             |
| `NGINX_ERROR_LOG_LEVEL`                   | `error`                     |             |
| `NGINX_ERROR_PAGE_403`                    |                             |             |
| `NGINX_ERROR_PAGE_404`                    |                             |             |
| `NGINX_GZIP_BUFFERS`                      | `16 8k`                     |             |
| `NGINX_GZIP_COMP_LEVEL`                   | `1`                         |             |
| `NGINX_GZIP_DISABLE`                      | `msie6`                     |             |
| `NGINX_GZIP_HTTP_VERSION`                 | `1.1`                       |             |
| `NGINX_GZIP_MIN_LENGTH`                   | `20`                        |             |
| `NGINX_GZIP_PROXIED`                      | `any`                       |             |
| `NGINX_GZIP_VARY`                         | `on`                        |             |
| `NGINX_GZIP`                              | `on`                        |             |
| `NGINX_HTTP2`                             |                             |             |
| `NGINX_INDEX_FILE`                        | `index.html index.htm`      |             |
| `NGINX_KEEPALIVE_REQUESTS`                | `100`                       |             |
| `NGINX_KEEPALIVE_TIMEOUT`                 | `75s`                       |             |
| `NGINX_LARGE_CLIENT_HEADER_BUFFERS`       | `8 16k`                     |             |
| `NGINX_LOG_FORMAT_OVERRIDE`               |                             |             |
| `NGINX_LOG_FORMAT_SHOW_REAL_IP`           |                             |             |
| `NGINX_MULTI_ACCEPT`                      | `on`                        |             |
| `NGINX_NO_DEFAULT_HEADERS`                |                             |             |
| `NGINX_PAGESPEED_ENABLE_FILTERS`          |                             |             |
| `NGINX_PAGESPEED_FILE_CACHE_PATH`         | `/var/cache/ngx_pagespeed/` |             |
| `NGINX_PAGESPEED_PRESERVE_URL_RELATIVITY` | `on`                        |             |
| `NGINX_PAGESPEED_REWRITE_LEVEL`           | `CoreFilters`               |             |
| `NGINX_PAGESPEED_STATIC_ASSET_PREFIX`     | `/pagespeed_static`         |             |
| `NGINX_PAGESPEED`                         | `unplugged`                 |             |
| `NGINX_RESET_TIMEDOUT_CONNECTION`         | `off`                       |             |
| `NGINX_SEND_TIMEOUT`                      | `60s`                       |             |
| `NGINX_SENDFILE`                          | `on`                        |             |
| `NGINX_SERVER_EXTRA_CONF_FILEPATH`        |                             |             |
| `NGINX_SERVER_NAME`                       | `default`                   |             |
| `NGINX_SERVER_ROOT`                       | `/var/www/html`             |             |
| `NGINX_SERVER_TOKENS`                     | `off`                       |             |
| `NGINX_STATIC_ACCESS_LOG`                 | `off`                       |             |
| `NGINX_STATIC_EXPIRES`                    | `7d`                        |             |
| `NGINX_STATIC_MP4_BUFFER_SIZE`            | `1M`                        |             |
| `NGINX_STATIC_MP4_MAX_BUFFER_SIZE`        | `5M`                        |             |
| `NGINX_STATIC_OPEN_FILE_CACHE_ERRORS`     | `on`                        |             |
| `NGINX_STATIC_OPEN_FILE_CACHE_MIN_USES`   | `2`                         |             |
| `NGINX_STATIC_OPEN_FILE_CACHE_VALID`      | `30s`                       |             |
| `NGINX_STATIC_OPEN_FILE_CACHE`            | `max=1000 inactive=30s`     |             |
| `NGINX_TCP_NODELAY`                       | `on`                        |             |
| `NGINX_TCP_NOPUSH`                        | `on`                        |             |
| `NGINX_TRACK_UPLOADS`                     | `uploads 60s`               |             |
| `NGINX_UNDERSCORES_IN_HEADERS`            | `off`                       |             |
| `NGINX_UPLOAD_PROGRESS`                   | `uploads 1m`                |             |
| `NGINX_USER`                              | `nginx`                     |             |
| `NGINX_VHOST_NO_DEFAULTS`                 |                             |             |
| `NGINX_VHOST_PRESET`                      | `html`                      |             |
| `NGINX_WORKER_CONNECTIONS`                | `1024`                      |             |
| `NGINX_WORKER_PROCESSES`                  | `auto`                      |             |

Static files extension defined via the regex and can be overriden via the env var `NGINX_STATIC_EXT_REGEX`, default:
```
css|cur|js|jpe?g|gif|htc|ico|png|xml|otf|ttf|eot|woff|woff2|svg|mp4|svgz|ogg|ogv|pdf|pptx?|zip|tgz|gz|rar|bz2|doc|xls|exe|tar|mid|midi|wav|bmp|rtf
```

Some environment variables can be overridden or added per [preset](#virtual-hosts-presets). 

## Modules

The list of installed modules can be found [here](https://github.com/wodby/nginx/blob/master/tests/basic/nginx_modules) 

## Virtual hosts presets

By default will be used `html` virtual host preset, you can change it via env var `$NGINX_VHOST_PRESET`. The list of available presets:

### HTML

This is the default preset.

* [Preset template](https://github.com/wodby/nginx/blob/master/templates/presets/html.conf.tmpl)
* Usage: this preset selected by default

### HTTP proxy (application server)

* [Preset template](https://github.com/wodby/nginx/blob/master/templates/presets/http-proxy.conf.tmpl)
* Usage: add `NGINX_VHOST_PRESET=http-proxy` and `NGINX_BACKEND_HOST=[host]` 

Additional environment variables for HTTP proxy preset:

| Variable             | Default Value | Description |
| -------------------- | ------------- | ----------- |
| `NGINX_BACKEND_HOST` |               |             |
| `NGINX_BACKEND_PORT` | `8080`        |             |

### PHP-based (FastCGI)

Additional environment variables for all php-based presets:

| Variable                           | Default Value | Description |
| ---------------------------------- | ------------- | ----------- |
| `NGINX_BACKEND_HOST`               | `php`         |             |
| `NGINX_BACKEND_PORT`               | `9000`        |             |
| `NGINX_FASTCGI_BUFFER_SIZE`        | `32k`         |             |
| `NGINX_FASTCGI_BUFFERS`            | `16 32k`      |             |
| `NGINX_FASTCGI_INTERCEPT_ERRORS`   | `on`          |             |
| `NGINX_FASTCGI_READ_TIMEOUT`       | `900`         |             |
| `NGINX_INDEX_FILE`                 | `index.php`   |             |

#### PHP

* [Preset template](https://github.com/wodby/nginx/blob/master/templates/presets/php.conf.tmpl)
* Usage: add `NGINX_VHOST_PRESET=php`, optionally modify `NGINX_BACKEND_HOST`

#### WordPress

* [Preset template](https://github.com/wodby/nginx/blob/master/templates/presets/wordpress.conf.tmpl)
* Usage: add `NGINX_VHOST_PRESET=wordpress`, optionally modify `NGINX_BACKEND_HOST`  

#### Drupal

Additional environment variables for Drupal presets:

| Variable                           | Default Value | Description                   |
| ---------------------------------- | ------------- | ----------------------------- |
| `NGINX_DRUPAL_ALLOW_XML_ENDPOINTS` |               |                               |
| `NGINX_DRUPAL_FILE_PROXY_URL`      |               | e.g. `http://dev.example.com` |
| `NGINX_DRUPAL_HIDE_HEADERS`        |               |                               |
| `NGINX_DRUPAL_XMLRPC_SERVER_NAME`  |               | D6 and D7 only                |

* Preset templates: [Drupal 8], [Drupal 7], [Drupal 6]
* Usage: add `NGINX_VHOST_PRESET=` with the value of `drupal8`, `drupal7` or `drupal6`. Optionally modify `NGINX_BACKEND_HOST`

[Drupal 8]: https://github.com/wodby/nginx/blob/master/templates/presets/drupal8.conf.tmpl
[Drupal 7]: https://github.com/wodby/nginx/blob/master/templates/presets/drupal7.conf.tmpl
[Drupal 6]: https://github.com/wodby/nginx/blob/master/templates/presets/drupal6.conf.tmpl

#### Custom preset

You can use a custom by preset by mounting your preset to `/etc/gotpl/presets/[my-preset-name].conf.tmpl` and setting `$NGINX_VHOST_PRESET=[my-preset-name]`.

#### No preset

To disable presets set `$NGINX_VHOST_PRESET=""`

## Customization

* Disable default recommended headers via `$NGINX_NO_DEFAULT_HEADERS` (defined in `nginx.conf`)
* Disable default rules included in virtual host via `$NGINX_VHOST_NO_DEFAULTS` 
* Add extra locations via `$NGINX_SERVER_EXTRA_CONF_FILEPATH=/filepath/to/nginx-locations.conf`, the file will be included at the end of virtual host config (`server` context)
* Define [custom preset](#custom-preset)
* Completely override include of the virtual host config by overriding `NGINX_CONF_INCLUDE`, it will be included in `nginx.conf`

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
