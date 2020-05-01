#################################################
Hive v3.1.2 - Hadoop Pseudo Distributed on Docker
#################################################

Quick and easy way to get Hive running with Hadoop running in `pseudo-distributed <https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/SingleCluste
r.html#Pseudo-Distributed_Operation>`_ mode using `Docker <https://docs.docker.com/install/>`_.

See `Apache Hive docs <https://hive.apache.org/>`_ for more information.

************
Quick Start
************

Impatient and just want Hive quickly?::

    $ docker run --rm -ti -d \
     --name hadoop-hive \
     loum/hadoop-hive:latest

More at `<https://hub.docker.com/r/loum/hadoop-pseudo>`_

*************
Prerequisties
*************

- `Docker <https://docs.docker.com/install/>`_
- `GNU make <https://www.gnu.org/software/make/manual/make.html>`_

***************
Getting Started
***************

Get the code and change into the top level ``git`` project directory::

    $ git clone https://github.com/loum/hadoop-hive.git && cd hadoop-hive

.. note::

    Run all commands from the top-level directory of the ``git`` repository.

For first-time setup, get the `Makester project <https://github.com/loum/makester.git>`_::

    $ git submodule update --init

Keep `Makester project <https://github.com/loum/makester.git>`_ up-to-date with::

    $ make submodule-update

Setup the environment::

    $ make init

************
Getting Help
************

There should be a ``make`` target to be able to get most things done.  Check the help for more information::

    $ make help

***********
Image Build
***********

::

    $ make bi

************************************
Interact with Hive using Beeline CLI
************************************

To simply start the container::

    $ make run

To start the container and wait for all Hadoop services to initiate::

    $ make controlled-run

Login to ``beeline`` (``!q`` to exit CLI)::

    $ make beeline

Check the `Beeline Command Reference <https://cwiki.apache.org/confluence/display/Hive/HiveServer2+Clients#HiveServer2Clients-Beeline%E2%80%93CommandLineShell>`_ for more.

Some other handy commands to run with ``beeline`` via ``make``:

Create a Hive table named ``test``::

    $ make beeline-create

To show tables::

    $ make beeline-show

To insert a row of data into Hive table ``test``::

    $ make beeline-insert

To select all rows in Hive table ``test``::

    $ make beeline-select

To drop the Hive table ``test``::

    $ make beeline-drop

Alternatively, port ``10000`` is exposed to allow connectivity to clients with JDBC.

To stop::

    $ make stop

Web Interfaces
==============

The following web interfaces are available to view configurations and logs:

- `Hadoop NameNode web UI <http://localhost:9870>`_
- `YARN ResourceManager web UI <http://localhost:8088>`_
- `HiveServer2 can be accessed via <http://localhost:10002>`_

.. note::

  Follow the link for more information on the `HiveServer2 web UI <https://cwiki.apache.org/confluence/display/Hive/Setting+Up+HiveServer2#SettingUpHiveServer2-WebUIforHiveServer2>`_

******************
Stop the Container
******************

::

    $ make stop

*********
Image Tag
*********

To apply tagging convention using ``<hadoop-version>-<hive-version>-<image-release-number>``::

    $ make tag MAKESTER__IMAGE_TAG=3.2.1-3.1.2-2
