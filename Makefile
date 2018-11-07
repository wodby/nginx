-include env_make

NGINX_VER ?= 1.15.6

NGINX_MINOR_VER ?= $(shell echo "${NGINX_VER}" | grep -oE '^[0-9]+\.[0-9]+')
TAG ?= $(NGINX_MINOR_VER)

REPO = wodby/nginx
NAME = nginx-$(NGINX_MINOR_VER)

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
	cd ./tests/basic && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./tests/wordpress && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./tests/drupal/8 && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./tests/drupal/7 && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./tests/drupal/6 && IMAGE=$(REPO):$(TAG) ./run.sh

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
