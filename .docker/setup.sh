#!/bin/sh
# Stop and remove any existing containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
# Build containers from Dockerfiles
docker pull sameersbn/mysql:latest
docker build -t mysql /app/.docker/mysql
docker build -f ./.docker/site/Dockerfile -t site-building ./
# Run and link the containers
docker run -d -p 3306:3306  --name site-building-mysql mysql:latest
docker run -d -p 8000:8000 -i -t -v /app:/app --link site-building-mysql:mysql --name site-building site-building-site:latest
docker run -d -p 88:88 -i -t -v ./:/app --name site-building site-building-site:latest
echo 'não pod c'