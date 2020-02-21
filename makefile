DOCKER_REGISTRY := mathematiguy
IMAGE_NAME := $(shell basename `git rev-parse --show-toplevel`)
IMAGE := $(DOCKER_REGISTRY)/$(IMAGE_NAME)
RUN ?= docker run $(DOCKER_ARGS) -v $$(pwd):/work -w /work -u $(UID):$(GID) $(IMAGE)
UID ?= $(shell id -u)
GID ?= $(shell id -g)
DOCKER_ARGS ?= --rm
GIT_TAG ?= $(shell git log --oneline | head -n1 | awk '{print $$1}')
LOG_LEVEL ?= INFO

all: data/results_data.csv

crawl: lotto/output.json

models/stan_model.stan: analysis/stan-simulations.R
	$(RUN) Rscript $<

data/results_data.csv: analysis/clean_data.R lotto/output.json
	$(RUN) Rscript $<

lotto/output.json:
	$(RUN) bash -c "cd lotto && scrapy crawl lottonumbers -o output.json 2>&1 | tee output.logs | grep $(LOG_LEVEL)"

daemon: UID=rstudio
daemon: GID=rstudio
daemon: DOCKER_ARGS= -dit --rm -e DISPLAY=$$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:ro --name="rdev"
daemon:
	$(RUN) R

clean:
	rm -f lotto/*.json lotto/*.logs data/*.csv

.PHONY: docker
docker:
	docker build --tag $(IMAGE):$(GIT_TAG) .
	docker tag $(IMAGE):$(GIT_TAG) $(IMAGE):latest

.PHONY: docker-push
docker-push:
	docker push $(IMAGE):$(GIT_TAG)
	docker push $(IMAGE):latest

.PHONY: docker-pull
docker-pull:
	docker pull $(IMAGE):$(GIT_TAG)
	docker tag $(IMAGE):$(GIT_TAG) $(IMAGE):latest

.PHONY: enter
enter: DOCKER_ARGS=-it
enter:
	$(RUN) bash

.PHONY: enter-root
enter-root: DOCKER_ARGS=-it
enter-root: UID=root
enter-root: GID=root
enter-root:
	$(RUN) bash

.PHONY: inspect-variables
inspect-variables:
	@echo DOCKER_REGISTRY: $(DOCKER_REGISTRY)
	@echo IMAGE_NAME:      $(IMAGE_NAME)
	@echo IMAGE:           $(IMAGE)
	@echo RUN:             $(RUN)
	@echo UID:             $(UID)
	@echo GID:             $(GID)
	@echo DOCKER_ARGS:     $(DOCKER_ARGS)
	@echo GIT_TAG:         $(GIT_TAG)
