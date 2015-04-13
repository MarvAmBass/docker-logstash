#!/bin/bash

if [ "empty" = "$(find /conf -maxdepth 0 -empty -exec echo empty \;)" ]
then
  >&2 echo ">> no configuration found... exiting"
  exit 1
else
  cp /conf/* /etc/logstash/conf.d/
fi

if [ "empty" = "$(find /patterns -maxdepth 0 -empty -exec echo empty \;)" ]
then
  echo ">> no additional patterns found..."
else
  cp /patterns/* /opt/logstash/patterns/
fi

if [ -z ${LOGSTASH_CN+x} ]
then
  LOGSTASH_CN="logstash"
fi

if [ -z ${LOGSTASH_IP+x} ]
then
  LOGSTASH_IP=$(ifconfig eth0 | grep "inet addr" | awk '{print $2}' | cut -d ":" -f2)
fi

if [ ! -f /certs/logstash-forwarder.key ] || [ ! -f /certs/logstash-forwarder.crt ]
then
  echo ">> no cert/key found... generating a pair"

  sed -i "s/# subjectAltName=email:copy/subjectAltName = IP: $LOGSTASH_IP/g" /etc/ssl/openssl.cnf

  openssl req -x509 -batch -nodes -config /etc/ssl/openssl.cnf \
    -newkey rsa:2048 \
    -subj "/CN=$LOGSTASH_CN/" \
    -keyout /certs/logstash-forwarder.key \
    -out /certs/logstash-forwarder.crt

  echo ""
  echo ""
  cat /certs/logstash-forwarder.key
  echo ""
  echo ""

  echo ""
  echo ""
  cat  /certs/logstash-forwarder.crt
  echo ""
  echo ""
  
  chmod a+rwx /certs/logstash-forwarder.crt /certs/logstash-forwarder.key
fi

echo ">> exec docker CMD"
echo "$@"
exec "$@"
