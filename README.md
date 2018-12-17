# Nginx Docker Container Images

[![Build Status](https://travis-ci.org/wodby/nginx.svg?branch=master)](https://travis-ci.org/wodby/nginx)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)
[![Docker Layers](https://images.microbadger.com/badges/image/wodby/nginx.svg)](https://microbadger.com/images/wodby/nginx)

* [Docker images](#docker-images)
* [Environment variables](#environment-variables)
* [Nginx modules](#nginx-modules)
* [ModSecurity](#modsecurity)
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

| Variable                                             | Default Value               | Description                            |
| -----------------------------------------            | --------------------------- | -----------                            |
| `NGINX_ALLOW_ACCESS_HIDDEN_FILES`                    |                             |                                        |
| `NGINX_BACKEND_FAIL_TIMEOUT`                         | `0`                         |                                        |
| `NGINX_BACKEND_HOST`                                 |                             |                                        |
| `NGINX_BACKEND_PORT`                                 |                             |                                        |
| `NGINX_CLIENT_BODY_BUFFER_SIZE`                      | `16k`                       |                                        |
| `NGINX_CLIENT_BODY_TIMEOUT`                          | `60s`                       |                                        |
| `NGINX_CLIENT_HEADER_BUFFER_SIZE`                    | `4k`                        |                                        |
| `NGINX_CLIENT_HEADER_TIMEOUT`                        | `60s`                       |                                        |
| `NGINX_CLIENT_MAX_BODY_SIZE`                         | `32m`                       |                                        |
| `NGINX_CONF_INCLUDE`                                 | `conf.d/*.conf`             |                                        |
| `NGINX_DISABLE_CACHING`                              |                             |                                        |
| `NGINX_ERROR_403_URI`                                |                             |                                        |
| `NGINX_ERROR_404_URI`                                |                             |                                        |
| `NGINX_ERROR_LOG_LEVEL`                              | `error`                     |                                        |
| `NGINX_ERROR_MESSAGE_50x`                            |                             |                                        |
| `NGINX_GZIP_BUFFERS`                                 | `16 8k`                     |                                        |
| `NGINX_GZIP_COMP_LEVEL`                              | `1`                         |                                        |
| `NGINX_GZIP_DISABLE`                                 | `msie6`                     |                                        |
| `NGINX_GZIP_HTTP_VERSION`                            | `1.1`                       |                                        |
| `NGINX_GZIP_MIN_LENGTH`                              | `20`                        |                                        |
| `NGINX_GZIP_PROXIED`                                 | `any`                       |                                        |
| `NGINX_GZIP_VARY`                                    | `on`                        |                                        |
| `NGINX_GZIP`                                         | `on`                        |                                        |
| `NGINX_HIDE_50x_ERRORS`                              |                             |                                        |
| `NGINX_HTTP2`                                        |                             |                                        |
| `NGINX_INDEX_FILE`                                   | `index.html index.htm`      | Default may vary depending on a preset |
| `NGINX_KEEPALIVE_REQUESTS`                           | `100`                       |                                        |
| `NGINX_KEEPALIVE_TIMEOUT`                            | `75s`                       |                                        |
| `NGINX_LARGE_CLIENT_HEADER_BUFFERS`                  | `8 16k`                     |                                        |
| `NGINX_LOG_FORMAT_OVERRIDE`                          |                             |                                        |
| `NGINX_MODSECURITY_INBOUND_ANOMALY_SCORE_THRESHOLD`  | `7`                         |                                        |
| `NGINX_MODSECURITY_OUTBOUND_ANOMALY_SCORE_THRESHOLD` | `7`                         |                                        |
| `NGINX_MODSECURITY_POST_CORE_RULES`                  |                             | Location to rules loaded after CRS     |
| `NGINX_MODSECURITY_PRE_CORE_RULES`                   |                             | Location to rules loaded before CRS    |
| `NGINX_MODSECURITY_USE_OWASP_CRS`                    |                             | See [ModSecurity](#modsecurity)        |
| `NGINX_MODSECURITY_ENABLE`                           |                             | See [ModSecurity](#modsecurity)        |
| `NGINX_MULTI_ACCEPT`                                 | `on`                        |                                        |
| `NGINX_NO_DEFAULT_HEADERS`                           |                             |                                        |
| `NGINX_PAGESPEED_ENABLE_FILTERS`                     |                             |                                        |
| `NGINX_PAGESPEED_FILE_CACHE_PATH`                    | `/var/cache/ngx_pagespeed/` |                                        |
| `NGINX_PAGESPEED_PRESERVE_URL_RELATIVITY`            | `on`                        |                                        |
| `NGINX_PAGESPEED_REWRITE_LEVEL`                      | `CoreFilters`               |                                        |
| `NGINX_PAGESPEED_STATIC_ASSET_PREFIX`                | `/pagespeed_static`         |                                        |
| `NGINX_PAGESPEED`                                    | `unplugged`                 |                                        |
| `NGINX_REAL_IP_HEADER`                               | `X-Real-IP`                 |                                        |
| `NGINX_REAL_IP_RECURSIVE`                            | `off`                       |                                        |
| `NGINX_RESET_TIMEDOUT_CONNECTION`                    | `off`                       |                                        |
| `NGINX_SEND_TIMEOUT`                                 | `60s`                       |                                        |
| `NGINX_SENDFILE`                                     | `on`                        |                                        |
| `NGINX_SERVER_EXTRA_CONF_FILEPATH`                   |                             |                                        |
| `NGINX_SERVER_NAME`                                  | `default`                   |                                        |
| `NGINX_SERVER_ROOT`                                  | `/var/www/html`             |                                        |
| `NGINX_SERVER_TOKENS`                                | `off`                       |                                        |
| `NGINX_SET_REAL_IP_FROM`                             |                             |                                        |
| `NGINX_STATIC_404_TRY_INDEX`                         |                             |                                        |
| `NGINX_STATIC_ACCESS_LOG`                            | `off`                       |                                        |
| `NGINX_STATIC_EXPIRES`                               | `7d`                        |                                        |
| `NGINX_STATIC_MP4_BUFFER_SIZE`                       | `1M`                        |                                        |
| `NGINX_STATIC_MP4_MAX_BUFFER_SIZE`                   | `5M`                        |                                        |
| `NGINX_STATIC_OPEN_FILE_CACHE_ERRORS`                | `on`                        |                                        |
| `NGINX_STATIC_OPEN_FILE_CACHE_MIN_USES`              | `2`                         |                                        |
| `NGINX_STATIC_OPEN_FILE_CACHE_VALID`                 | `30s`                       |                                        |
| `NGINX_STATIC_OPEN_FILE_CACHE`                       | `max=1000 inactive=30s`     |                                        |
| `NGINX_TCP_NODELAY`                                  | `on`                        |                                        |
| `NGINX_TCP_NOPUSH`                                   | `on`                        |                                        |
| `NGINX_TRACK_UPLOADS`                                | `uploads 60s`               |                                        |
| `NGINX_UNDERSCORES_IN_HEADERS`                       | `off`                       |                                        |
| `NGINX_UPLOAD_PROGRESS`                              | `uploads 1m`                |                                        |
| `NGINX_USER`                                         | `nginx`                     |                                        |
| `NGINX_VHOST_NO_DEFAULTS`                            |                             |                                        |
| `NGINX_VHOST_PRESET`                                 | `html`                      |                                        |
| `NGINX_WORKER_CONNECTIONS`                           | `1024`                      |                                        |
| `NGINX_WORKER_PROCESSES`                             | `auto`                      |                                        |

Static files extension defined via the regex and can be overridden via the env var `NGINX_STATIC_EXT_REGEX`, default:
```
css|cur|js|jpe?g|gif|htc|ico|png|xml|otf|ttf|eot|woff|woff2|svg|mp4|svgz|ogg|ogv|pdf|pptx?|zip|tgz|gz|rar|bz2|doc|xls|exe|tar|mid|midi|wav|bmp|rtf|txt
```

Some environment variables can be overridden or added per [preset](#virtual-hosts-presets). 

## Nginx modules

| Name                       | Version                                                   |
| -------------------------- | --------------------------------------------------------- |
| [http_addition]            |                                                           |
| [http_auth_request]        |                                                           |
| [http_dav]                 |                                                           |
| [http_flv]                 |                                                           |
| [http_geoip]               |                                                           |
| [http_gunzip]              |                                                           |
| [http_gzip_static]         |                                                           |
| [http_image_filter]        |                                                           |
| [http_mp4]                 |                                                           |
| [http_random_index]        |                                                           |
| [http_realip]              |                                                           |
| [http_secure_link]         |                                                           |
| [http_slice]               |                                                           |
| [http_ssl]                 |                                                           |
| [http_stub_status]         |                                                           |
| [http_sub]                 |                                                           |
| [http_v2]                  |                                                           |
| [http_xslt]                |                                                           |
| [mail_ssl]                 |                                                           |
| [modsecurity]              | module 1.0.0 ([modsecurity lib] 3.0.3, [OWASP CRS] 3.1.0) |
| [pagespeed]                | 1.13.35.2                                                 |
| [uploadprogress]           | 0.9.1                                                     |
| [stream_geoip]             |                                                           |
| [stream_realip]            |                                                           |
| [stream_ssl]               |                                                           |
| [stream_ssl_preread]       |                                                           |

## ModSecurity

ModSecurity is disabled by default, to enable set `$NGINX_MODSECURITY_ENABLE` to any value. Additionally, you can enable [OWASP Core Rule Set (CRS)](https://modsecurity.org/crs/) by setting `$NGINX_MODSECURITY_USE_OWASP_CRS` to any value, ️be wary since it may [block some requests](https://github.com/wodby/nginx/pull/14#issuecomment-447404035) with the default configuration. See env vars starting with `$NGINX_MODSECURITY_` for advanced configuration.  

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
* `$NGINX_INDEX_FILE` set to `index.php` by default

#### WordPress

* [Preset template](https://github.com/wodby/nginx/blob/master/templates/presets/wordpress.conf.tmpl)
* Usage: add `NGINX_VHOST_PRESET=wordpress`, optionally modify `NGINX_BACKEND_HOST`  
* Access to `*.txt` files allowed only if they are located in uploads directory

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
* If you want to use [stage_file_proxy](https://www.drupal.org/project/stage_file_proxy) module, set `$NGINX_STATIC_404_TRY_INDEX=1` to redirect 404 static files requests to Drupal
* Access to `*.txt` files allowed only if they are located in files directory 

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

[http_addition]: http://nginx.org/en/docs/http/ngx_http_addition_module.html
[http_auth_request]: http://nginx.org/en/docs/http/ngx_http_auth_request_module.html
[http_dav]: http://nginx.org/en/docs/http/ngx_http_dav_module.html
[http_flv]: http://nginx.org/en/docs/http/ngx_http_flv_module.html
[http_geoip]: http://nginx.org/en/docs/http/ngx_http_geoip_module.html
[http_gunzip]: http://nginx.org/en/docs/http/ngx_http_gunzip_module.html
[http_gzip_static]: http://nginx.org/en/docs/http/ngx_http_gzip_static_module.html
[http_image_filter]: http://nginx.org/en/docs/http/ngx_http_image_filter_module.html
[http_mp4]: http://nginx.org/en/docs/http/ngx_http_mp4_module.html
[http_random_index]: http://nginx.org/en/docs/http/ngx_http_random_index_module.html
[http_realip]: http://nginx.org/en/docs/http/ngx_http_realip_module.html
[http_secure_link]: http://nginx.org/en/docs/http/ngx_http_secure_link_module.html
[http_slice]: http://nginx.org/en/docs/http/ngx_http_slice_module.html
[http_ssl]: http://nginx.org/en/docs/http/ngx_http_ssl_module.html
[http_stub_status]: http://nginx.org/en/docs/http/ngx_http_stub_status_module.html
[http_sub]: http://nginx.org/en/docs/http/ngx_http_sub_module.html
[http_v2]: http://nginx.org/en/docs/http/ngx_http_v2_module.html
[http_xslt]: http://nginx.org/en/docs/http/ngx_http_xslt_module.html
[mail_ssl]: http://nginx.org/en/docs/mail/ngx_mail_ssl_module.html
[modsecurity lib]: https://modsecurity.org/
[modsecurity]: https://github.com/SpiderLabs/ModSecurity-nginx
[OWASP CRS]: https://modsecurity.org/crs/
[pagespeed]: https://github.com/apache/incubator-pagespeed-ngx
[stream_geoip]: http://nginx.org/en/docs/stream/ngx_stream_geoip_module.html
[stream_realip]: http://nginx.org/en/docs/stream/ngx_stream_realip_module.html
[stream_ssl]: http://nginx.org/en/docs/stream/ngx_stream_ssl_module.html
[stream_ssl_preread]: http://nginx.org/en/docs/stream/ngx_stream_ssl_preread_module.html
[uploadprogress]: https://github.com/masterzen/nginx-upload-progress-module
