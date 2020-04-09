# Include overrides (must occur before include statements).
MAKESTER__REPO_NAME := loum
MAKESTER__CONTAINER_NAME := hadoop-hive

include makester/makefiles/base.mk
include makester/makefiles/docker.mk
include makester/makefiles/python-venv.mk

MAKESTER__RUN_COMMAND := $(DOCKER) run --rm -d\
 --name $(MAKESTER__CONTAINER_NAME)\
 --publish 8088:8088\
 --publish 10000:10000\
 $(MAKESTER__SERVICE_NAME):$(HASH)

init: makester-requirements

bi: build-image

build-image:
	@$(DOCKER) build -t $(MAKESTER__SERVICE_NAME):$(HASH) .

rmi: rm-image

rm-image:
	@$(DOCKER) rmi $(MAKESTER__SERVICE_NAME):$(HASH) || true

backoff:
	@$(PYTHON) makester/scripts/backoff -d "Hiverserver2" -p 10000 localhost

controlled-run: run backoff

login:
	@$(DOCKER) exec -ti $(MAKESTER__CONTAINER_NAME) bash || true

beeline: backoff
	@$(DOCKER) exec -ti $(MAKESTER__CONTAINER_NAME)\
 bash -c "HADOOP_HOME=/opt/hadoop /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000"

beeline-cmd: backoff
	@$(DOCKER) exec -ti $(MAKESTER__CONTAINER_NAME)\
 bash -c "HADOOP_HOME=/opt/hadoop /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000 -e $(BEELINE_CMD)"

beeline-create: BEELINE_CMD = 'CREATE TABLE test (c CHAR(10))'

beeline-show: BEELINE_CMD = 'SHOW TABLES;'

beeline-drop: BEELINE_CMD = 'DROP TABLE test;'

beeline-create beeline-show beeline-drop: beeline-cmd

help: base-help docker-help python-venv-help
	@echo "(Makefile)\n\
  build-image:         Build docker image $(MAKESTER__SERVICE_NAME):$(HASH) (alias bi)\n\
  rm-image:            Delete docker image $(MAKESTER__SERVICE_NAME):$(HASH) (alias rmi) \n\
  login:               Login to container $(MAKESTER__CONTAINER_NAME)\n\
  beeline:             Execute beeline CLI on $(MAKESTER__CONTAINER_NAME)\n\
  beeline-create:      Execute beeline CLI \"CREATE TABLE ...\" on $(MAKESTER__CONTAINER_NAME)\n\
  beeline-create:      Execute beeline CLI \"SHOW TABLES\" on $(MAKESTER__CONTAINER_NAME)\n\
  beeline-drop:        Execute beeline CLI \"DROP TABLE ...\" on $(MAKESTER__CONTAINER_NAME)\n\
	";

.PHONY: help
