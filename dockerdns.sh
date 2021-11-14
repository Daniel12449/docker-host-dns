#!/bin/bash

hosts=/etc/hosts

sed -i '/#-DockerDNS-Entries/,/#-End-DockerDNS-Entries/d' $hosts

echo "#-DockerDNS-Entries" >> $hosts

containers=$(docker ps | awk '{if(NR>1) print $NF}')

for container in $containers
do
  ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container)
  echo "$ip $container" >> $hosts
done

echo "#-End-DockerDNS-Entries" >> $hosts
