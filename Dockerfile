FROM ubuntu
MAINTAINER Scott Clasen "scott@heroku.com"

# SRM: Proxy, so we can work within firewall
ENV http_proxy http://example.proxy.com:123
ENV https_proxy http://example.proxy.com:123

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

# SRM:ADD is not really great for long downloads, especially behind proxy so resorting to wget.
RUN wget http://mirror.symnds.com/software/Apache/zookeeper/zookeeper-3.4.5/zookeeper-3.4.5.tar.gz -P /zookeeper/
RUN $(cd /zookeeper && tar xfz zookeeper-3.4.5.tar.gz)

# SRM:ADD is not really great for long downloads, especially behind proxy so resorting to wget.
RUN wget http://ringmaster-exhibitor.s3.amazonaws.com/exhibitor-standalone-1.4.7.jar -P /exhibitor/
ADD exhibitor.properties /exhibitor/exhibitor.properties
ADD start-exhibitor.sh /exhibitor/bin/start-exhibitor.sh

EXPOSE 8080 2181 2888 3888 
CMD ["/exhibitor/bin/start-exhibitor.sh"]

