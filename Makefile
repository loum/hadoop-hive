# Include overrides (must occur before include statements).
MAKESTER__REPO_NAME = loum
MAKESTER__CONTAINER_NAME = hadoop-hive

include makester/makefiles/makester.mk
include makester/makefiles/docker.mk
include makester/makefiles/python-venv.mk

MAKESTER__RUN_COMMAND := $(DOCKER) run --rm -d\
 --name $(MAKESTER__CONTAINER_NAME)\
 --publish 9000:9000\
 --publish 8088:8088\
 --publish 9870:9870\
 --publish 10000:10000\
 --publish 10002:10002\
 $(MAKESTER__SERVICE_NAME):$(HASH)

init: makester-requirements

backoff:
	@$(PYTHON) makester/scripts/backoff -d "Hadoop NameNode port" -p 9000 localhost
	@$(PYTHON) makester/scripts/backoff -d "Hadoop NameNode web UI port" -p 9870 localhost
	@$(PYTHON) makester/scripts/backoff -d "YARN ResourceManager web UI port" -p 8088 localhost
	@$(PYTHON) makester/scripts/backoff -d "Web UI for HiveServer2" -p 10002 localhost
	@$(PYTHON) makester/scripts/backoff -d "HiveServer2" -p 10000 localhost

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

beeline-insert: BEELINE_CMD = 'INSERT INTO TABLE test VALUES ('\''test'\'');'

beeline-select: BEELINE_CMD = 'SELECT * FROM test;'

beeline-drop: BEELINE_CMD = 'DROP TABLE test;'

beeline-create beeline-show beeline-insert beeline-select beeline-drop: beeline-cmd

help: makester-help docker-help python-venv-help
	@echo "(Makefile)\n\
  login:               Login to container $(MAKESTER__CONTAINER_NAME)\n\
  beeline:             Start beeline CLI on $(MAKESTER__CONTAINER_NAME)\n\
  beeline-create:      Execute beeline command \"CREATE TABLE ...\" on $(MAKESTER__CONTAINER_NAME)\n\
  beeline-show:        Execute beeline command \"SHOW TABLES\" on $(MAKESTER__CONTAINER_NAME)\n\
  beeline-insert:      Execute beeline command \"INSERT INTO TABLE ...\" on $(MAKESTER__CONTAINER_NAME)\n\
  beeline-select:      Execute beeline command \"SELECT * FROM ...\" on $(MAKESTER__CONTAINER_NAME)\n\
  beeline-drop:        Execute beeline command \"DROP TABLE ...\" on $(MAKESTER__CONTAINER_NAME)\n"

.PHONY: help
