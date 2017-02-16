-include env_make

VERSION ?= 1.10

REPO = wodby/nginx
NAME = nginx-1.10

.PHONY: build test push shell run start stop logs clean release

build:
	docker build -t $(REPO):$(VERSION) ./

test:
	docker run -d --name $(NAME) -e DEBUG=1 -p 8080:80 $(REPO):$(VERSION)
	./test.sh
	make clean

push:
	docker push $(REPO):$(VERSION)

shell:
	docker run --rm --name $(NAME) -i -t $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(VERSION) /bin/bash

run:
	docker run --rm --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(VERSION) $(CMD)

start:
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(VERSION)

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

release: build
	make push -e VERSION=$(VERSION)

default: build
