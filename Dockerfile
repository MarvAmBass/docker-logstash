FROM marvambass/oracle-java8

RUN apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4

ENV LOGSTASH_MAJOR 1.4
ENV LOGSTASH_VERSION 1.4.2-1-2c0f5a1

RUN echo "deb http://packages.elasticsearch.org/logstash/${LOGSTASH_MAJOR}/debian stable main" > /etc/apt/sources.list.d/logstash.list

RUN apt-get update; apt-get install -y --no-install-recommends \
    logstash=$LOGSTASH_VERSION

ENV PATH /opt/logstash/bin:$PATH

COPY entrypoint.sh /

VOLUME ["/conf", "/certs", "/patterns"]

EXPOSE 5000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["logstash", "agent", "-f", "/etc/logstash/conf.d"]
