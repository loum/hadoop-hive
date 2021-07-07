# Hive v3.1.2: Hadoop Pseudo Distributed on Docker
- [Overview](#Overview)
- [Quick Links](#Quick-Links)
- [Quick Start](#Quick-Start)
- [Prerequisites](#Prerequisites)
- [Getting Started](#Getting-Started)
- [Getting Help](#Getting-Help)
- [Docker Image Management](#Docker-Image-Management)
  - [Image Build](#Image-Build)
  - [Image Searches](#Image-Searches)
  - [Image Tagging](#Image-Tagging)
- [Interact with Hive using Beeline CLI](#Interact-with-Hive-using-Beeline-CLI)
- [Web Interfaces](#Web-Interfaces)

## Overview
Quick and easy way to get Hive running with Hadoop running in [pseudo-distributed](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/SingleCluster.html#Pseudo-Distributed_Operation) mode using [Docker](https://docs.docker.com/install/).

## Quick Links
- [Apache Hive docs](https://hive.apache.org/)

## Quick Start
Impatient and just want Hive quickly?:
```
docker run --rm -d --name hadoop-hive loum/hadoop-hive:latest
```
More at https://hub.docker.com/r/loum/hadoop-pseudo.

## Prerequisties
- [Docker](https://docs.docker.com/install/)
- [GNU make](https://www.gnu.org/software/make/manual/make.html)

## Getting Started
Get the code and change into the top level `git` project directory:
```
git clone https://github.com/loum/hadoop-hive.git && cd hadoop-hive
```
> **_NOTE:_** Run all commands from the top-level directory of the `git` repository.

For first-time setup, prime the [Makester project](https://github.com/loum/makester.git):
```
git submodule update --init
```
Keep [Makester project](https://github.com/loum/makester.git) up-to-date with:
```
make submodule-update
```
Setup the environment:
```
make init
```
## Getting Help

There should be a `make` target for most things.  Check the help for more information:
```
make help
```
## Docker Image Management
### Image Build
When you are ready to build the image:
```
make build-image
```
### Image Searches
Search for existing Docker image tags with command:
```
make search-image
```
### Image Tagging
By default, `makester` will tag the new Docker image with the current branch hash.  This provides a degree of uniqueness but is not very intuitive.  That's where the `tag-version` `Makefile` target can help.  To apply tag as per project tagging convention `<hadoop-version>-<hive-version>-<image-release-number>`
```
make tag-version
```
To tag the image as `latest`
```
make tag-latest
```
## Interact with Hive using Beeline CLI
To start the container and wait for all Hadoop services to initiate:
```
make controlled-run
```
Login to `beeline` (`!q` to exit CLI):
```
make beeline
```
Check the [Beeline Command Reference](https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-Beeline%E2%80%93CommandLineShell) for more.

Create a Hive table named ``test`:
```
make beeline-create
```
To show tables:
```
make beeline-show
```
To insert a row of data into Hive table `test`:
```
make beeline-insert
```
To select all rows in Hive table `test`:
```
make beeline-select
```
To drop the Hive table `test`:
```
make beeline-drop
```
Alternatively, port `10000` is exposed to allow connectivity to clients with JDBC.

To stop:
```
make stop
```
## Web Interfaces
The following web interfaces are available to view configurations and logs:

- Hadoop NameNode web UI: http://localhost:9870
- YARN ResourceManager web UI: http://localhost:8088
- HiveServer2: http://localhost:10002

> Follow the link for more information on the [HiveServer2 web UI](https://cwiki.apache.org/confluence/display/Hive/Setting+Up+HiveServer2#SettingUpHiveServer2-WebUIforHiveServer2)

[top](Hive-v3.1.2:-Hadoop-Pseudo-Distributed-on-Docker)
