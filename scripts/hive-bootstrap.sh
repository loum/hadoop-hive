#!/bin/sh
set -x

HADOOP_HOME=/opt/hadoop
HIVE_HOME=/opt/hive

# Starting from Hive 2.1, we need to run the schematool command below as an initialization step.
runuser -l hdfs -c "$HIVE_HOME/bin/schematool -dbType derby -initSchema"

# Start the Hiverserver2.
runuser -l hdfs -c "HADOOP_HOME=$HADOOP_HOME $HIVE_HOME/bin/hiveserver2 > /tmp/hiveserver2.out 2>&1 &"
