#!/bin/sh

#Clean Old Logs (every startup will clean older logs so the machine never get FS full)
for item in $(find /var/lib/docker/containers/ -type f -name '*.log') ;do truncate -s 0 $item ;done

service docker start
docker start site-building-mysql
docker start site-building
