host ?= localhost
max_try ?= 1
wait_seconds ?= 1
delay_seconds ?= 0
command_http = curl -s -o /dev/null -I -w '%{http_code}' ${host}/.healthz | grep -q 204
# TODO: find a better way to parse headers
command_http2 = nghttp -v http://${host}/.healthz | grep -qE 'recv.+?:status: 204$$'
service = Nginx

default: check-ready

init:
	init
.PHONY: init

check-ready:
    ifeq ($(NGINX_HTTP2),)
		wait_for "$(command_http)" $(service) $(host) $(max_try) $(wait_seconds) $(delay_seconds)
    else
		wait_for "$(command_http2)" $(service) $(host) $(max_try) $(wait_seconds) $(delay_seconds)
    endif
.PHONY: check-ready

check-live:
	@echo "OK"
.PHONY: check-live
