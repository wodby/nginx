.PHONY: check-ready check-live

host ?= localhost
max_try ?= 1
wait_seconds ?= 1

default: check-ready

check-ready:
	wait-for-nginx.sh $(host) $(max_try) $(wait_seconds)

check-live:
	@echo "OK"
