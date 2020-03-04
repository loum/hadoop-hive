#######################################
Hive v3.1.2 - Hadoop Pseudo Distributed
#######################################

Quick and easy way to get Hive running in Hadoop pseudo distributed mode using docker.

See `Apache Hive docs <https://hive.apache.org/>`_ for more information.

*************
Prerequisties
*************

- `Docker <https://docs.docker.com/install/>`_

***************
Getting Started
***************

Get the code and change into the top level `git` project directory::

    $ git clone https://github.com/loum/hadoop-hive.git && cd hadoop-hive

.. note::

    Run all commands from the top-level directory of the `git` repository.

For first-time setup, get the `Makester project <https://github.com/loum/makester.git>`_::

    $ git submodule update --init

Keep `Makester project <https://github.com/loum/makester.git>`_ up-to-date with::

    $ git submodule update --remote --merge

************
Getting Help
************

There should be a `make` target to be able to get most things done.  Check the help for more information::

    $ make help

***********
Image Build
***********

::

    $ make bi

*******************
Start the Container
*******************

::

    $ make run

************************************
Interact with Hive using Beeline CLI
************************************

Login to `beeline` (`!q` to exit CLI)::

    $ make beeline

Check the `Beeline Command Reference <https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-Beeline%E2%80%93CommandLineShell>`_ for more.

To run `beeline` commands via `docker exec`::

    $ docker exec hive sh -c "HADOOP_HOME=/opt/hadoop /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000 -e \"SHOW DATABASES\"\;"

Alternatively, port `10000` is exposed to allow connectivity to clients with JDBC.

******************
Stop the Container
******************

::

    $ make stop
