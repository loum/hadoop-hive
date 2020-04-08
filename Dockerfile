ARG HIVE_VERSION=hive-3.1.2

FROM ubuntu:bionic-20200311 AS downloader

RUN apt-get update && apt-get install -y --no-install-recommends\
 wget

ARG HIVE_VERSION

RUN wget -qO- http://apache.mirror.serversaustralia.com.au/hive/${HIVE_VERSION}/apache-${HIVE_VERSION}-bin.tar.gz | tar -C /tmp -xzf -

### downloader layer end

FROM loum/hadoop-pseudo:3.2.1-2

USER root

ARG HIVE_VERSION

COPY --from=downloader /tmp/apache-${HIVE_VERSION}-bin /opt/apache-${HIVE_VERSION}-bin
RUN ln -s /opt/apache-${HIVE_VERSION}-bin /opt/hive &&\
 chown -R root:root /opt/apache-${HIVE_VERSION}-bin

# Temporary workaround for conflicting guava jars.
#
# See https://stackoverflow.com/questions/58176627/how-can-i-ask-hive-to-provide-more-detailed-error
# for more detail.
RUN rm /opt/hive/lib/guava-19.0.jar && \
  cp /opt/hadoop/share/hadoop/common/lib/guava-27.0-jre.jar /opt/hive/lib/

COPY files/hive-site.xml /opt/hive/conf/

COPY scripts/hive-bootstrap.sh /hive-bootstrap.sh

# Hiverserver2 port.
EXPOSE 10000

ARG HADOOP_USER=hdfs
ARG HADOOP_HOME=/opt/hadoop
ARG HIVE_HOME=/opt/hive

USER ${HADOOP_USER}
WORKDIR /home/${HADOOP_USER}

# Add Hadoop/Hive executables to HADOOP_USER PATH.
RUN sed -i "s|^export PATH=|export PATH=${HIVE_HOME}\/bin:|" ~/.bashrc

CMD [ "/hive-bootstrap.sh" ]
