FROM ubuntu
MAINTAINER Scott Clasen "scott@heroku.com"

RUN echo deb http://archive.ubuntu.com/ubuntu precise universe >> /etc/apt/sources.list
RUN apt-get update

RUN apt-get install -q -y curl telnet wget git 
# UGH THIS BLOCK IS FOR THE JDK
RUN apt-get install libfuse2
RUN cd /tmp ; apt-get download fuse
RUN cd /tmp ; dpkg-deb -x fuse_* .
RUN cd /tmp ; dpkg-deb -e fuse_*
RUN cd /tmp ; rm fuse_*.deb
RUN cd /tmp ; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst
RUN cd /tmp ; dpkg-deb -b . /fuse.deb
RUN cd /tmp ; dpkg -i /fuse.deb

RUN apt-get install -q -y openjdk-7-jdk 

RUN mkdir -p /zookeeper/data
RUN mkdir -p /exhibitor/bin

ADD http://www.gtlib.gatech.edu/pub/apache/zookeeper/zookeeper-3.4.5/zookeeper-3.4.5.tar.gz /zookeeper/zookeeper-3.4.5.tar.gz
RUN $(cd /zookeeper && tar xfz zookeeper-3.4.5.tar.gz)

ADD http://ringmaster-exhibitor.s3.amazonaws.com/exhibitor-standalone-1.4.7.jar /exhibitor/exhibitor-standalone-1.4.7.jar


ADD exhibitor.properties /exhibitor/exhibitor.properties
ADD start-exhibitor.sh /exhibitor/bin/start-exhibitor.sh
ADD pipework /pipework

EXPOSE 8080 2181 2888 3888 
CMD ["/exhibitor/bin/start-exhibitor.sh"]

