#!/bin/sh

nohup sh -c /hadoop-bootstrap.sh &

# Pause until Hadoop bootstrap completes.
counter=0
sleep_time=5
break_out=19
file_to_check="/tmp/hadoop-hdfs-nodemanager.pid"
while : ; do
    if [ -f "$file_to_check" -o $counter -gt $break_out ]
    then
        if [ -f "$file_to_check" ]
        then
            echo "### Hadoop bootstrap complete"
        else
            echo "### ERROR: Hadoop boostrap timeout"
        fi
        break
    else
        echo "$0 pausing until $file_to_check exists."
        sleep $sleep_time
        counter=$((counter+$sleep_time))
    fi
done

HADOOP_HOME=/opt/hadoop
HIVE_HOME=/opt/hive

# Starting from Hive 2.1, we need to run the schematool command below as an initialisation step.
echo "### Running schematool for Hive initialisation ..."
HADOOP_HOME=$HADOOP_HOME $HIVE_HOME/bin/schematool -dbType derby -initSchema
echo "### schematool done"

# Start the Hiverserver2.
echo "### Starting Hiveserver2"
$HIVE_HOME/bin/hs2-ctrl start

# Block until we signal exit.
trap 'exit 0' TERM
while true; do sleep 0.5; done
