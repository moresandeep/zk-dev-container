#! /usr/bin/env bash

set -e

echo  "com.netflix.exhibitor.servers-spec=1:$HOSTNAME" >> /exhibitor/exhibitor.properties

java -jar /exhibitor/exhibitor-standalone-1.4.7.jar --fsconfigdir /exhibitor --nodemodification true --configtype file --hostname $HOSTNAME
