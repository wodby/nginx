-include env_make

NGINX_VER ?= 1.27.4
NGINX_VER_MINOR ?= $(shell echo "${NGINX_VER}" | grep -oE '^[0-9]+\.[0-9]+')

TAG ?= $(NGINX_VER_MINOR)

ALPINE_VER ?= 3.20

PLATFORM ?= linux/amd64

ifeq ($(WODBY_USER_ID),)
    WODBY_USER_ID := 1000
endif

ifeq ($(WODBY_GROUP_ID),)
    WODBY_GROUP_ID := 1000
endif

ifeq ($(BASE_IMAGE_STABILITY_TAG),)
    BASE_IMAGE_TAG := $(ALPINE_VER)
else
    BASE_IMAGE_TAG := $(ALPINE_VER)-$(BASE_IMAGE_STABILITY_TAG)
endif

REGISTRY ?= docker.io
REPO = $(REGISTRY)/wodby/nginx
NAME = nginx-$(NGINX_VER_MINOR)

ifneq ($(ARCH),)
	override TAG := $(TAG)-$(ARCH)
endif

.PHONY: build buildx-build buildx-push buildx-build-amd64 test push shell run start stop logs clean release

default: build

build:
	docker build -t $(REPO):$(TAG) \
        --build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
	    --build-arg NGINX_VER=$(NGINX_VER) \
		--build-arg WODBY_GROUP_ID=$(WODBY_GROUP_ID) \
		--build-arg WODBY_USER_ID=$(WODBY_USER_ID) ./

buildx-build:
	docker buildx build --platform $(PLATFORM) \
		--build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
		--build-arg NGINX_VER=$(NGINX_VER) \
		--build-arg WODBY_GROUP_ID=$(WODBY_GROUP_ID) \
		--build-arg WODBY_USER_ID=$(WODBY_USER_ID) \
		-t $(REPO):$(TAG) ./

buildx-push:
	docker buildx build --platform $(PLATFORM) \
		--build-arg BASE_IMAGE_TAG=$(BASE_IMAGE_TAG) \
		--build-arg NGINX_VER=$(NGINX_VER) \
		--build-arg WODBY_GROUP_ID=$(WODBY_GROUP_ID) \
		--build-arg WODBY_USER_ID=$(WODBY_USER_ID) \
		--push -t $(REPO):$(TAG) ./

buildx-imagetools-create:
	docker buildx imagetools create -t $(REPO):$(TAG) \
				$(REPO):$(NGINX_VER_MINOR)-amd64 \
				$(REPO):$(NGINX_VER_MINOR)-arm64
.PHONY: buildx-imagetools-create

test:
	cd ./tests/basic && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./tests/php && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./tests/matomo && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./tests/wordpress && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./tests/drupal/11 && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./tests/drupal/10 && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./tests/drupal/9 && IMAGE=$(REPO):$(TAG) ./run.sh
	cd ./tests/drupal/7 && IMAGE=$(REPO):$(TAG) ./run.sh

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
