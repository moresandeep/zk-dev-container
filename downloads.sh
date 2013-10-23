#! /usr/bin/env bash

#run before docker build, so if you are deving you dont have to keep redownloading stuff

curl -O  http://www.gtlib.gatech.edu/pub/apache/zookeeper/zookeeper-3.4.5/zookeeper-3.4.5.tar.gz 

curl -O http://ringmaster-exhibitor.s3.amazonaws.com/exhibitor-standalone-1.4.7.jar 
