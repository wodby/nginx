-include env_make

NGINX_VER ?= 1.20.0
NGINX_MINOR_VER ?= $(shell echo "${NGINX_VER}" | grep -oE '^[0-9]+\.[0-9]+')

TAG ?= $(NGINX_MINOR_VER)

ALPINE_VER ?= 3.13

PLATFORM ?= linux/amd64

ifeq ($(BASE_IMAGE_STABILITY_TAG),)
    BASE_IMAGE_TAG := $(ALPINE_VER)
else
    BASE_IMAGE_TAG := $(ALPINE_VER)-$(BASE_IMAGE_STABILITY_TAG)
endif

REPO = wodby/nginx
NAME = nginx-$(NGINX_MINOR_VER)

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

.PHONY: build buildx-build buildx-push buildx-build-amd64 test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) \
        --build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
	    --build-arg NGINX_VER=$(NGINX_VER) ./

# --load  doesn't work with multiple platforms https://github.com/docker/buildx/issues/59
# we need to save cache to run tests first.
buildx-build-amd64:
	docker buildx build --platform linux/amd64 \
		--build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
		--build-arg NGINX_VER=$(NGINX_VER) \
		--load \
		-t $(REPO):$(TAG) ./

buildx-build:
	docker buildx build --platform $(PLATFORM) \
		--build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
		--build-arg NGINX_VER=$(NGINX_VER) \
		-t $(REPO):$(TAG) ./

buildx-push:
	docker buildx build --platform $(PLATFORM) \
		--build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
		--build-arg NGINX_VER=$(NGINX_VER) \
		--push -t $(REPO):$(TAG) ./

test:
	cd ./tests/basic && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./tests/php && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./tests/wordpress && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./tests/drupal/9 && IMAGE=$(REPO):$(TAG) ./run.sh
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
