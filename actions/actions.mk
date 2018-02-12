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
command = curl -s -o /dev/null -I -w '%{http_code}' ${host}/.healthz | grep -q 204
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
	wait-for.sh "$(command)" $(service) $(host) $(max_try) $(wait_seconds) $(delay_seconds)

check-live:
	@echo "OK"
