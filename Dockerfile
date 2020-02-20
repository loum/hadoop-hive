FROM loum/hadoop-pseudo:3.2.1

ARG HIVE_VERSION=hive-3.1.2

RUN wget -P /tmp http://apache.mirror.serversaustralia.com.au/hive/${HIVE_VERSION}/apache-${HIVE_VERSION}-bin.tar.gz
RUN tar xzf /tmp/apache-${HIVE_VERSION}-bin.tar.gz -C /opt && \
  ln -s /opt/apache-${HIVE_VERSION}-bin /opt/hive && \
  rm /tmp/apache-${HIVE_VERSION}-bin.tar.gz && \
  chown -R root:root /opt/apache-${HIVE_VERSION}-bin.tar.gz

# Add Hive executables to hdfs user PATH.
USER hdfs
RUN sed -i 's/:$PATH/:\/opt\/hive\/bin:$PATH/' ~/.profile

# Temporary workaround for conflicting guava jars.
#
# See https://stackoverflow.com/questions/58176627/how-can-i-ask-hive-to-provide-more-detailed-error
# for more detail.
USER root
RUN rm /opt/hive/lib/guava-19.0.jar && \
  cp /opt/hadoop/share/hadoop/common/lib/guava-27.0-jre.jar /opt/hive/lib/

COPY files/hive-site.xml /opt/hive/conf/

COPY scripts/hive-bootstrap.sh /hive-bootstrap.sh
CMD [ "/hive-bootstrap.sh" ]
