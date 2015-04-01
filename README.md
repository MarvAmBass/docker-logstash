# Docker ELK-Stack Container - Logstash
_maintained by MarvAmBass_

[FAQ - All you need to know about the marvambass Containers](https://marvin.im/docker-faq-all-you-need-to-know-about-the-marvambass-containers/)

## What is it

This Dockerfile (available as ___marvambass/logstash___) gives you a ready to use Logstash Container for your ELK stack or something else.

View in Docker Registry [marvambass/logstash](https://registry.hub.docker.com/u/marvambass/marvambass/logstash/)

View in GitHub [MarvAmBass/docker-logstash](https://github.com/MarvAmBass/docker-logstash)

## Environment variables and defaults

### Variables

* __LOGSTASH\_IP__
 * default: the current ip of the docker container itself
 * you should set this to the ip you want to connect to your logstash server
 
* __LOGSTASH\_CN__
 * default: _logstash_
 * you should set this to the common name of your logstash server

### Cert Filenames

* __/certs/logstash-forwarder.crt__
* __/certs/logstash-forwarder.key__

Those are the two files needed to connect your logstash forwarder to logstash securly. They'll be generated if they don't exist - but you can create your own and put them there.

## Running marvambass/logstash Container

First of all you could start my [elasticsearch container](https://github.com/MarvAmBass/docker-elasticsearch) (Kibana needs a Elasticsearch instance to work) like this:

    docker run -d \
    --name elasticsearch \
    -v "$PWD/esdata":/usr/share/elasticsearch/data
    marvambass/elasticsearch

Now the Logstash Container:

    docker run -d \
    --name logstash \
    --link elasticsearch:elasticsearch \
    -v "$PWD/conf:/conf" \
    -v "$PWD/certs:/certs" \
    marvambass/logstash

_we create a new container and link it tou our elasticsearch instance by the name __elasticsearch__, we also overwrite the _/conf_ directory with our own configuration directory and the _/certs_ directory to use our certs.

## Based on

This Dockerfile is based on my [marvambass/oracle-java8](https://registry.hub.docker.com/marvambass/oracle-java8) Image.
