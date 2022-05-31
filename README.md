# Nginx Docker Container Images

[![Build Status](https://github.com/wodby/nginx/workflows/Build%20docker%20image/badge.svg)](https://github.com/wodby/nginx/actions)
[![Docker Pulls](https://img.shields.io/docker/pulls/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)
[![Docker Stars](https://img.shields.io/docker/stars/wodby/nginx.svg)](https://hub.docker.com/r/wodby/nginx)

- [Docker images](#docker-images)
- [Environment variables](#environment-variables)
- [Build arguments](#build-arguments)
- [Nginx modules](#nginx-modules)
    - [ModSecurity]
- [Default behaviour](#default-behavior)
- [Customization](#customization)
- [Virtual hosts presets](#virtual-hosts-presets)
    - [HTML](#html)
    - [HTTP proxy (application server)](#http-proxy-application-server)
    - [Django](#django)
    - [PHP-based (FastCGI)](#PHP-based-fastcgi)
        - [PHP](#php)
        - [WordPress](#wordpress)
        - [Drupal](#drupal)
        - [Matomo](#matomo)
    - [Custom preset](#custom-preset)
    - [No preset](#no-preset)
- [Orchestration actions](#orchestration-actions)

## Docker Images

❗For better reliability we release images with stability tags (`wodby/nginx:1.21-X.X.X`) which correspond
to [git tags](https://github.com/wodby/nginx/releases). We strongly recommend using images only with stability tags.

Overview:

- All images based on Alpine Linux
- Base image: [wodby/alpine](https://github.com/wodby/alpine)
- [GitHub actions builds](https://github.com/wodby/nginx/actions)
- [Docker Hub](https://hub.docker.com/r/wodby/nginx)

Supported tags and respective `Dockerfile` links:

- `1.21`, `1`, `latest` [_(Dockerfile)_](https://github.com/wodby/nginx/tree/master/Dockerfile)
- `1.20` [_(Dockerfile)_](https://github.com/wodby/nginx/tree/master/Dockerfile)
- `1.19` [_(Dockerfile)_](https://github.com/wodby/nginx/tree/master/Dockerfile)

All images built for `linux/amd64` and `linux/arm64`

## Environment Variables

| Variable                                             | Default Value                 | Description                                                                                                                                                                                                                                                                                                                                            |
|------------------------------------------------------|-------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `NGINX_ALLOW_ACCESS_HIDDEN_FILES`                    |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_BACKEND_FAIL_TIMEOUT`                         | `0`                           |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_BACKEND_HOST`                                 | Varies with a preset          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_BACKEND_PORT`                                 | Varies with a preset          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_BROTLI`                                       | `on`                          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_BROTLI_STATIC`                                | `on`                          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_BROTLI_COMP_LEVEL`                            | `1`                           |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_CLIENT_BODY_BUFFER_SIZE`                      | `16k`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_CLIENT_BODY_TIMEOUT`                          | `60s`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_CLIENT_HEADER_BUFFER_SIZE`                    | `4k`                          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_CLIENT_HEADER_TIMEOUT`                        | `60s`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_CLIENT_MAX_BODY_SIZE`                         | `32m`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_CONF_INCLUDE`                                 | `conf.d/*.conf`               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_DISABLE_CACHING`                              |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_DJANGO_MEDIA_ROOT`                            | `/var/www/html/media/`        |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_DJANGO_MEDIA_URL`                             | `/media/`                     |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_DJANGO_STATIC_ROOT`                           | `/var/www/html/static/`       |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_DJANGO_STATIC_URL`                            | `/static/`                    |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_DRUPAL_ALLOW_XML_ENDPOINTS`                   |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_DRUPAL_FILE_PROXY_URL`                        |                               | e.g. `http://dev.example.com`                                                                                                                                                                                                                                                                                                                          |
| `NGINX_DRUPAL_FILES_STATIC_EXT_REGEX`                | `txt`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_DRUPAL_HIDE_HEADERS`                          |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_DRUPAL_XMLRPC_SERVER_NAME`                    |                               | Drupal 6/7 only                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_DRUPAL_NOT_FOUND_REGEX`                       | (see [Drupal](#drupal))       |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_WP_NOT_FOUND_REGEX`                           | (see [Wordpress](#wordpress)) |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_ERROR_403_URI`                                |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_ERROR_404_URI`                                |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_ERROR_LOG_LEVEL`                              | `error`                       |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_ERROR_MESSAGE_50x`                            |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_FASTCGI_BUFFER_SIZE`                          | `32k`                         | For PHP-based presets only                                                                                                                                                                                                                                                                                                                             |
| `NGINX_FASTCGI_BUFFERS`                              | `16 32k`                      | For PHP-based presets only                                                                                                                                                                                                                                                                                                                             |
| `NGINX_FASTCGI_INDEX`                                | `index.php`                   | For PHP-based presets only                                                                                                                                                                                                                                                                                                                             |
| `NGINX_FASTCGI_INTERCEPT_ERRORS`                     | `on`                          | For PHP-based presets only                                                                                                                                                                                                                                                                                                                             |
| `NGINX_FASTCGI_READ_TIMEOUT`                         | `900`                         | For PHP-based presets only                                                                                                                                                                                                                                                                                                                             |
| `NGINX_GZIP_BUFFERS`                                 | `16 8k`                       |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_GZIP_COMP_LEVEL`                              | `1`                           |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_GZIP_DISABLE`                                 | `msie6`                       |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_GZIP_HTTP_VERSION`                            | `1.1`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_GZIP_MIN_LENGTH`                              | `20`                          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_GZIP_PROXIED`                                 | `any`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_GZIP_VARY`                                    | `on`                          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_GZIP`                                         | `on`                          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_HEADERS_CONTENT_SECURITY_POLICY`              | `frame-ancestors: 'none'`     | `off` to disable, different for Drupal and WP presets                                                                                                                                                                                                                                                                                                  |
| `NGINX_HEADERS_CONTENT_TYPE_OPTIONS`                 | `nosniff`                     | `off` to disable                                                                                                                                                                                                                                                                                                                                       |
| `NGINX_HEADERS_CSP_REPORT_ONLY`                      | `off`                         | `off` to disable, e.g. `default-src 'self'; report-uri https://example.report-uri.com/r/d/csp/reportOnly;`                                                                                                                                                                                                                                             |
| `NGINX_HEADERS_FRAME_OPTIONS`                        | `SAMEORIGIN`                  | `off` to disable                                                                                                                                                                                                                                                                                                                                       |
| `NGINX_HEADERS_NEL`                                  | `off`                         | `off` to disable, e.g. `{"report_to":"default","max_age":31536000,"include_subdomains":true}`                                                                                                                                                                                                                                                          |
| `NGINX_HEADERS_PERMISSIONS_POLICY`                   | `off`                         | `off` to disable, e.g. `accelerometer=(),autoplay=(),camera=(),display-capture=(),document-domain=(),encrypted-media=(),fullscreen=(),geolocation=(),gyroscope=(),magnetometer=(),microphone=(),midi=(),payment=(),picture-in-picture=(),publickey-credentials-get=(),screen-wake-lock=(),sync-xhr=(self),usb=(),web-share=(),xr-spatial-tracking=()`  |
| `NGINX_HEADERS_REFERRER_POLICY`                      | `off`                         | `off` to disable, e.g. `strict-origin-when-cross-origin`                                                                                                                                                                                                                                                                                               |
| `NGINX_HEADERS_REPORT_TO`                            | `off`                         | `off` to disable, e.g. `{"group":"default","max_age":31536000,"endpoints":[{"url":"https://example.report-uri.com/a/d/g"}],"include_subdomains":true}  `                                                                                                                                                                                               |
| `NGINX_HEADERS_XSS_PROTECTION`                       | `'1; mode=block'`             | `off` to disable                                                                                                                                                                                                                                                                                                                                       |
| `NGINX_HIDE_50x_ERRORS`                              |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_HTTP2`                                        |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_INDEX_FILE`                                   | Varies with a preset          | Hard-coded for Drupal and WP                                                                                                                                                                                                                                                                                                                           |
| `NGINX_KEEPALIVE_REQUESTS`                           | `100`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_KEEPALIVE_TIMEOUT`                            | `75s`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_LARGE_CLIENT_HEADER_BUFFERS`                  | `8 16k`                       |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_LOG_FORMAT_OVERRIDE`                          |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_METRICS_ENABLED`                              | `off`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_METRICS_FORMAT`                               | `html`                        | html, json, jsonp, prometheus                                                                                                                                                                                                                                                                                                                          |
| `NGINX_METRICS_ALLOW_FROM`                           |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_MODSECURITY_ENABLED`                          |                               | See [ModSecurity]                                                                                                                                                                                                                                                                                                                                      |
| `NGINX_MODSECURITY_INBOUND_ANOMALY_SCORE_THRESHOLD`  | `7`                           |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_MODSECURITY_OUTBOUND_ANOMALY_SCORE_THRESHOLD` | `7`                           |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_MODSECURITY_POST_CORE_RULES`                  |                               | Location to rules loaded after CRS                                                                                                                                                                                                                                                                                                                     |
| `NGINX_MODSECURITY_PRE_CORE_RULES`                   |                               | Location to rules loaded before CRS                                                                                                                                                                                                                                                                                                                    |
| `NGINX_MODSECURITY_USE_OWASP_CRS`                    |                               | See [ModSecurity]                                                                                                                                                                                                                                                                                                                                      |
| `NGINX_MULTI_ACCEPT`                                 | `on`                          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_NO_DEFAULT_HEADERS`                           |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_REAL_IP_HEADER`                               | `X-Real-IP`                   |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_REAL_IP_RECURSIVE`                            | `off`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_RESET_TIMEDOUT_CONNECTION`                    | `off`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_SEND_TIMEOUT`                                 | `60s`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_SENDFILE`                                     | `on`                          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_SERVER_EXTRA_CONF_FILEPATH`                   |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_SERVER_NAME`                                  | `default`                     |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_SERVER_ROOT`                                  | `/var/www/html`               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_SERVER_TOKENS`                                | `off`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_SET_REAL_IP_FROM`                             |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_SET_REAL_IPS_FROM`                            |                               | json array as string                                                                                                                                                                                                                                                                                                                                   |
| `NGINX_STATIC_404_TRY_INDEX`                         |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_STATIC_ACCESS_LOG`                            | `off`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_STATIC_EXPIRES`                               | `1y`                          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_STATIC_MP4_BUFFER_SIZE`                       | `1M`                          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_STATIC_MP4_MAX_BUFFER_SIZE`                   | `5M`                          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_STATIC_OPEN_FILE_CACHE_ERRORS`                | `on`                          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_STATIC_OPEN_FILE_CACHE_MIN_USES`              | `2`                           |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_STATIC_OPEN_FILE_CACHE_VALID`                 | `30s`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_STATIC_OPEN_FILE_CACHE`                       | `max=1000 inactive=30s`       |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_STATIC_EXT_REGEX`                             | (see below)                   |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_STATUS_ALLOW_FROM`                            |                               | e.g. `172.18.0.0/16`                                                                                                                                                                                                                                                                                                                                   |
| `NGINX_STATUS_ENABLED`                               | `off`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_TCP_NODELAY`                                  | `on`                          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_TCP_NOPUSH`                                   | `on`                          |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_TRACK_UPLOADS`                                | `uploads 60s`                 |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_UNDERSCORES_IN_HEADERS`                       | `off`                         |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_UPLOAD_PROGRESS`                              | `uploads 1m`                  |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_USER`                                         | `nginx`                       |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_VHOST_NO_DEFAULTS`                            |                               |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_VHOST_PRESET`                                 | `html`                        |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_WORKER_CONNECTIONS`                           | `1024`                        |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_WORKER_PROCESSES`                             | `auto`                        |                                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_WP_FILE_PROXY_URL`                            |                               | e.g. `http://dev.example.com`                                                                                                                                                                                                                                                                                                                          |
| `NGINX_WP_GOOGLE_XML_SITEMAP`                        |                               | See [WordPress]                                                                                                                                                                                                                                                                                                                                        |
| `NGINX_WP_YOAST_XML_SITEMAP`                         |                               | See [WordPress]                                                                                                                                                                                                                                                                                                                                        |

Static files extension defined via the regex and can be overridden via the env var `NGINX_STATIC_EXT_REGEX`, default:

```
css|cur|js|jpe?g|gif|htc|ico|png|xml|otf|ttf|eot|woff|woff2|svg|mp4|svgz|ogg|ogv|pdf|pptx?|zip|tgz|gz|rar|bz2|doc|xls|exe|tar|mid|midi|wav|bmp|rtf|txt|map|webp
```

Some environment variables can be overridden or added per [preset](#virtual-hosts-presets).

## Build arguments

| Argument         | Default value |
|------------------|---------------|
| `WODBY_GROUP_ID` | `1000`        |
| `WODBY_USER_ID`  | `1000`        |

## Nginx modules

| Name                  | Version           | Dynamic |
|-----------------------|-------------------|---------|
| [brotli]              | [9aec15e]         |         |
| [http_addition]       |                   |         |
| [http_auth_request]   |                   |         |
| [http_dav]            |                   |         |
| [http_flv]            |                   |         |
| [http_gunzip]         |                   |         |
| [http_gzip_static]    |                   |         |
| [http_image_filter]   |                   | ✓       |
| http_modsecurity      | See [ModSecurity] | ✓       |
| [http_mp4]            |                   |         |
| [http_random_index]   |                   |         |
| [http_realip]         |                   |         |
| [http_secure_link]    |                   |         |
| [http_slice]          |                   |         |
| [http_ssl]            |                   |         |
| [http_stub_status]    |                   |         |
| [http_sub]            |                   |         |
| [http_uploadprogress] | 0.9.1             |         |
| [http_v2]             |                   |         |
| [http_xslt]           |                   | ✓       |
| [mail_ssl]            |                   |         |
| [stream_realip]       |                   |         |
| [stream_ssl]          |                   |         |
| [stream_ssl_preread]  |                   |         |
| [vts]                 | [3c6cf41]         |         |

### ModSecurity

| Component                  | Version |
|----------------------------|---------|
| [ModSecurity Nginx module] | 1.0.0   |
| [ModSecurity Library]      | 3.0.3   |
| [OWASP CRS]                | 3.1.0   |

Compiled as a dynamic module, disabled by default. To enable set `$NGINX_MODSECURITY_ENABLED` to any value.
Additionally, you can enable [OWASP Core Rule Set (CRS)](https://modsecurity.org/crs/) by
setting `$NGINX_MODSECURITY_USE_OWASP_CRS` to any value, ️be wary since it
may [block some requests](https://github.com/wodby/nginx/pull/14#issuecomment-447404035) with the default configuration.
See env vars starting with `$NGINX_MODSECURITY_` for advanced configuration.

## Default behavior

Applied to all presets by default, can be disabled via `$NGINX_VHOST_NO_DEFAULTS`:

- `/.well-known/` location supported
- `/ads.txt` allowed
- `/robots.txt` allowed
- `/humans.txt` allowed
- `/favicon.ico` allowed
- `.flv`, `.m4a`, `.mp4`, `.mov` locations supported and handled with appropriate modules
- `/.healthz` location supported, requests not shown in access log

## Customization

- Pass real IP from a reverse proxy via `$NGINX_SET_REAL_IP_FROM`, e.g. `172.17.0.0/16` for docker network
- Pass multiple real IP from reverse proxies via `$NGINX_SET_REAL_IPS_FROM`
  In a docker-compose.yml this can be done like this:
  ```
  environment:
    NGINX_SET_REAL_IPS_FROM: "[\"172.17.0.0/16\", \"192.168.0.10\"]"

  environment:
    NGINX_SET_REAL_IPS_FROM: |-
      ["172.17.0.0/16", "192.168.0.10"]
  ```
- Customize the header which value will be used to replace the client address via `$NGINX_REAL_IP_HEADER`
- Default recommended headers can be disabled via `$NGINX_NO_DEFAULT_HEADERS` (defined in `nginx.conf`)
- The value for the Content-Security-Policy header can be changed using `$NGINX_HEADERS_CONTENT_SECURITY_POLICY`, it's
  default value is `frame-ancestors: 'none'`. More information on this header can be
  found [here](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy).
- Error page file can be customized for HTTP errors `403` (`$NGINX_ERROR_403_URI`) and `404` (`$NGINX_ERROR_404_URI`)
- Default error page for HTTP errors `500`, `502`, `503`, `504` can be disabled via `$NGINX_HIDE_50x_ERRORS`
- Access to hidden files (starting with `.`) can be allowed via `$NGINX_ALLOW_ACCESS_HIDDEN_FILES`
- Caching can be disabled via `$NGINX_DISABLE_CACHING`
- Add extra locations via `$NGINX_SERVER_EXTRA_CONF_FILEPATH=/filepath/to/nginx-locations.conf`, the file will be
  included at the end of default rules (`server` context)
- Completely override include of the virtual host config by overriding `NGINX_CONF_INCLUDE`, it will be included
  in `nginx.conf`
- Define [custom preset](#custom-preset)
- Status page `/.statusz` can be enabled via `$NGINX_STATUS_ENABLED`, requests not shown in access log
- Metrics page `/.metricsz` can be enabled via `$NGINX_METRICS_ENABLED`, requests not shown in access log
- Metrics page format can be customized via `$NGINX_METRICS_FORMAT`, supports json, html, jsonp and prometheus

## Virtual hosts presets

Virtual host preset `html` will be used by default, you can change it via env var `$NGINX_VHOST_PRESET`. The list of
available presets:

### HTML

- [Preset template](https://github.com/wodby/nginx/blob/master/templates/presets/html.conf.tmpl)
- Usage: this preset selected by default

Overridden default values:

| Variable           | Default Value |
|--------------------|---------------|
| `NGINX_INDEX_FILE` | `index.html`  |

### HTTP proxy (application server)

- [Preset template](https://github.com/wodby/nginx/blob/master/templates/presets/http-proxy.conf.tmpl)
- Usage: add `NGINX_VHOST_PRESET=http-proxy` and `NGINX_BACKEND_HOST=[HOST]`

Overridden default values:

| Variable             | Default Value |
|----------------------|---------------|
| `NGINX_BACKEND_HOST` |               |
| `NGINX_BACKEND_PORT` | `8080`        |

### Django

Same as HTTP proxy but with additional media/static locations for Django.

- [Preset template](https://github.com/wodby/nginx/blob/master/templates/presets/django.conf.tmpl)
- Usage: add `NGINX_VHOST_PRESET=django`

Overridden default values:

| Variable             | Default Value |
|----------------------|---------------|
| `NGINX_BACKEND_HOST` | `python`      |
| `NGINX_BACKEND_PORT` | `8080`        |

### PHP-based (FastCGI)

Overridden default values:

| Variable             | Default Value |
|----------------------|---------------|
| `NGINX_BACKEND_HOST` | `php`         |
| `NGINX_BACKEND_PORT` | `9000`        |

#### PHP

* [Preset template](https://github.com/wodby/nginx/blob/master/templates/presets/php.conf.tmpl)
* Usage: add `NGINX_VHOST_PRESET=php`, optionally modify `NGINX_BACKEND_HOST`

Overridden default values:

| Variable           | Default Value          |
|--------------------|------------------------|
| `NGINX_INDEX_FILE` | `index.php index.html` |

#### WordPress

- [Preset template](https://github.com/wodby/nginx/blob/master/templates/presets/wordpress.conf.tmpl)
- Usage: add `NGINX_VHOST_PRESET=wordpress`, optionally modify `NGINX_BACKEND_HOST`
- Access to `*.txt` files allowed only if they are located in uploads directory
- Access to `/wp-content/uploads/woocommerce_uploads` disallowed
- Dynamic generated `/robots.txt` supported
- Supports `/wp-sitemap.xml` endpoint
- Alternative `sitemap.xml` endpoints:
    - For plugin [Google XML Sitemap](https://wordpress.org/plugins/google-sitemap-generator/)
      add `$NGINX_WP_GOOGLE_XML_SITEMAP=1`
    - For plugin [Yoast SEO](https://kb.yoast.com/kb/xml-sitemaps-nginx/) add `$NGINX_WP_YOAST_XML_SITEMAP=1`
- Default value of `NGINX_HEADERS_CONTENT_SECURITY_POLICY` overridden to `frame-ancestors: 'self'`

Default value of NGINX_WP_NOT_FOUND_REGEX (backspaces must be escaped) is: `.+\\.(?:txt|pot|sh|.*sql?)|(?:composer\\.(json|lock)|(package|package-lock)\\.json|yarn\\.lock)$`

#### Drupal

- Preset templates: [Drupal 9], [Drupal 8], [Drupal 7], [Drupal 6]
- Usage: add `NGINX_VHOST_PRESET=` with the value of `drupal9`, `drupal8`, `drupal7` or `drupal6`. Optionally
  modify `NGINX_BACKEND_HOST`
- If you want to use [stage_file_proxy](https://www.drupal.org/project/stage_file_proxy) module,
  set `$NGINX_STATIC_404_TRY_INDEX=1` to redirect 404 static files requests to Drupal
- Access to `.txt` (can be overridden via `NGINX_DRUPAL_FILES_STATIC_EXT_REGEX`) files allowed only if they are located in files directory
- Access to certs extensions gives 404 based on the value of `$NGINX_DRUPAL_NOT_FOUND_REGEX`
- Default value of `NGINX_HEADERS_CONTENT_SECURITY_POLICY` overridden to `frame-ancestors: 'self'`

Default value of `NGINX_DRUPAL_NOT_FOUND_REGEX` (backspaces must be escaped) is taken from Drupal's `.htaccess` and
depends on the Drupal version:

Drupal 9/8:

```
\\.(engine|txt|inc|install|make|module|profile|po|sh|.*sql|theme|twig|tpl(\\.php)?|xtmpl|yml|yaml)(~|\\.sw[op]|\\.bak|\\.orig|\\.save)?$|^(\\.(?!well-known).*|Entries.*|Repository|Root|Tag|Template|composer\\.(json|lock)|(package|package-lock)\\.json|yarn\\.lock|web\\.config)$|^#.*#$|\\.php(~|\\.sw[op]|\\.bak|\\.orig|\\.save)$
```

Drupal 7:

```
\\.(engine|txt|inc|info|install|make|module|profile|test|po|sh|.*sql|theme|tpl(\\.php)?|xtmpl|yml|yaml)(~|\\.sw[op]|\\.bak|\\.orig|\\.save)?$|^(\\.(?!well-known).*|Entries.*|Repository|Root|Tag|Template|composer\\.(json|lock)|(package|package-lock)\\.json|yarn\\.lock|web\\.config)$|^#.*#$|\\.php(~|\\.sw[op]|\\.bak|\\.orig\\.save)$
```

Drupal 6:

```
\\.(engine|txt|inc|info|install|make|module|profile|test|po|sh|.*sql|theme|tpl(\\.php)?|xtmpl|svn-base|yaml|yml)$|^(code-style\\.pl|Entries.*|Repository|Root|Tag|Template|all-wcprops|entries|format)$
```

[Drupal 9]: https://github.com/wodby/nginx/blob/master/templates/presets/drupal9.conf.tmpl

[Drupal 8]: https://github.com/wodby/nginx/blob/master/templates/presets/drupal8.conf.tmpl

[Drupal 7]: https://github.com/wodby/nginx/blob/master/templates/presets/drupal7.conf.tmpl

[Drupal 6]: https://github.com/wodby/nginx/blob/master/templates/presets/drupal6.conf.tmpl

#### Matomo

Based on https://github.com/matomo-org/matomo-nginx

The default value of `NGINX_STATIC_EXT_REGEX` overridden:

```
css|cur|js|jpe?g|gif|htc|ico|png|xml|otf|ttf|eot|woff|woff2|svg|mp4|svgz|ogg|ogv|pdf|pptx?|zip|tgz|gz|rar|bz2|doc|xls|exe|tar|mid|midi|wav|bmp|rtf|txt|map|webp|json|html
```

#### Custom preset

You can use a custom by preset by mounting your preset to `/etc/gotpl/presets/[my-preset-name].conf.tmpl` and
setting `$NGINX_VHOST_PRESET=[my-preset-name]`.

#### No preset

To disable presets set `$NGINX_VHOST_PRESET=""`

## Maintenance

Updates to Nginx and base image automated via [wodby/images](https://github.com/wodby/images).

## Orchestration actions

Usage:

```
make COMMAND [params ...]

commands:
    init
    git-checkout [target is_hash]
    check-ready [host max_try wait_seconds delay_seconds]

default params values:
    host localhost
    max_try 1
    wait_seconds 1
    delay_seconds 0
```

[brotli]: https://github.com/google/ngx_brotli

[http_addition]: http://nginx.org/en/docs/http/ngx_http_addition_module.html

[http_auth_request]: http://nginx.org/en/docs/http/ngx_http_auth_request_module.html

[http_dav]: http://nginx.org/en/docs/http/ngx_http_dav_module.html

[http_flv]: http://nginx.org/en/docs/http/ngx_http_flv_module.html

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

[http_uploadprogress]: https://github.com/masterzen/nginx-upload-progress-module

[http_v2]: http://nginx.org/en/docs/http/ngx_http_v2_module.html

[http_xslt]: http://nginx.org/en/docs/http/ngx_http_xslt_module.html

[mail_ssl]: http://nginx.org/en/docs/mail/ngx_mail_ssl_module.html

[ModSecurity Library]: https://modsecurity.org/

[ModSecurity Nginx module]: https://github.com/SpiderLabs/ModSecurity-nginx

[ModSecurity]: #modsecurity

[OWASP CRS]: https://modsecurity.org/crs/

[WordPress]: #wordpress

[stream_realip]: http://nginx.org/en/docs/stream/ngx_stream_realip_module.html

[stream_ssl]: http://nginx.org/en/docs/stream/ngx_stream_ssl_module.html

[stream_ssl_preread]: http://nginx.org/en/docs/stream/ngx_stream_ssl_preread_module.html

[vts]: https://github.com/vozlt/nginx-module-vts

[9aec15e]: https://github.com/google/ngx_brotli/commit/9aec15e2aa6feea2113119ba06460af70ab3ea62
[3c6cf41]: https://github.com/vozlt/nginx-module-vts/commit/3c6cf41315bfcb48c35a3a0be81ddba6d0d01dac
