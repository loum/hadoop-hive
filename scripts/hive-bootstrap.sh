#!/bin/sh

/usr/sbin/sshd -f ~/.ssh/sshd_config

# Start NameNode daemon and DataNode daemon.
/opt/hadoop/sbin/start-dfs.sh

# Start ResourceManager daemon and NodeManager daemon.
/opt/hadoop/sbin/start-yarn.sh

HADOOP_HOME=/opt/hadoop
HIVE_HOME=/opt/hive

# Starting from Hive 2.1, we need to run the schematool command below as an initialization step.
cd /home/hdfs && HADOOP_HOME=$HADOOP_HOME $HIVE_HOME/bin/schematool -dbType derby -initSchema

# Start the Hiverserver2.
HADOOP_HOME=$HADOOP_HOME $HIVE_HOME/bin/hiveserver2
