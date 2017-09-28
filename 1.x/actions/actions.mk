.PHONY: check-ready check-live

host ?= localhost
max_try ?= 1
wait_seconds ?= 1
delay_seconds ?= 0
command = curl -s "${host}/.healthz" &> /dev/null
service = Nginx

default: check-ready

check-ready:
	wait-for.sh "$(command)" $(service) $(host) $(max_try) $(wait_seconds) $(delay_seconds)

check-live:
	@echo "OK"
