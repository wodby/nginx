.PHONY: git-clone git-checkout check-ready check-live

check_defined = \
    $(strip $(foreach 1,$1, \
        $(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
    $(if $(value $1),, \
      $(error Required parameter is missing: $1$(if $2, ($2))))

host ?= localhost
max_try ?= 1
wait_seconds ?= 1
delay_seconds ?= 0
command_http = curl -s -o /dev/null -I -w '%{http_code}' ${host}/.healthz | grep -q 204
# TODO: find a better way to parse headers
command_http2 = nghttp -v http://${host}/.healthz | grep -qE 'recv.+?:status: 204$$'
service = Nginx
is_hash ?= 0
branch = ""

default: check-ready

git-clone:
	$(call check_defined, url)
	git-clone.sh $(url) $(branch)

git-checkout:
	$(call check_defined, target)
	git-checkout.sh $(target) $(is_hash)

check-ready:
    ifeq ($(NGINX_HTTP2),)
		wait-for.sh "$(command_http)" $(service) $(host) $(max_try) $(wait_seconds) $(delay_seconds)
    else
		wait-for.sh "$(command_http2)" $(service) $(host) $(max_try) $(wait_seconds) $(delay_seconds)
    endif

check-live:
	@echo "OK"
