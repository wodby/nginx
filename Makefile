-include env_make

NGINX_VER ?= 1.13.7
TAG ?= $(NGINX_VER)

REPO = wodby/nginx
NAME = nginx-$(NGINX_VER)

ifneq ($(STABILITY_TAG),)
ifneq ($(TAG),latest)
    override TAG := $(TAG)-$(STABILITY_TAG)
endif
endif

.PHONY: build test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) --build-arg NGINX_VER=$(NGINX_VER) ./

test:
	./test.sh $(NAME) $(REPO):$(TAG)

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) $(CMD)

start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

release: build push
