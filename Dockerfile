ARG HIVE_VERSION
ARG UBUNTU_BASE_IMAGE
ARG HADOOP_PSEUDO_BASE_IMAGE

FROM ubuntu:$UBUNTU_BASE_IMAGE AS downloader

RUN apt-get update && apt-get install -y --no-install-recommends\
 wget

ARG HIVE_VERSION

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN wget -qO- http://apache.mirror.serversaustralia.com.au/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz | tar -C /tmp -xzf -

### downloader layer end

FROM loum/hadoop-pseudo:$HADOOP_PSEUDO_BASE_IMAGE

USER root

ARG HIVE_VERSION
ARG HIVE_HOME=/opt/hive

COPY --from=downloader /tmp/apache-hive-${HIVE_VERSION}-bin /opt/apache-hive-${HIVE_VERSION}-bin
RUN ln -s /opt/apache-hive-${HIVE_VERSION}-bin ${HIVE_HOME} &&\
 chown -R root:root /opt/apache-hive-${HIVE_VERSION}-bin

# Temporary workaround for conflicting guava jars.
#
# See https://stackoverflow.com/questions/58176627/how-can-i-ask-hive-to-provide-more-detailed-error
# for more detail.
RUN rm ${HIVE_HOME}/lib/guava-19.0.jar && \
  cp /opt/hadoop/share/hadoop/common/lib/guava-27.0-jre.jar ${HIVE_HOME}/lib/

COPY files/hive-site.xml ${HIVE_HOME}/conf/

COPY scripts/hs2-ctrl /opt/hive/bin/hs2-ctrl
COPY scripts/hive-bootstrap.sh /hive-bootstrap.sh

# HiveServer2 port.
EXPOSE 10000

# Web UI for HiveServer2 port.
EXPOSE 10002

ARG HADOOP_USER=hdfs
ARG HADOOP_HOME=/opt/hadoop

USER ${HADOOP_USER}
WORKDIR /home/${HADOOP_USER}

# Add Hadoop/Hive executables to HADOOP_USER PATH.
RUN sed -i "s|^export PATH=|export PATH=${HIVE_HOME}\/bin:|" ~/.bashrc

ENTRYPOINT [ "/hive-bootstrap.sh" ]
