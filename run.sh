#!/bin/bash

base_dir=$(pwd)
echo $base_dir

# Install mysql container
cd $base_dir/mysql
docker build --no-cache=true --rm=true -t mysql5.6 .
docker rm -f mysql5.6
docker run -it -d --name mysql5.6 -p 3306:3306 -e MYSQL_USER=thang -e MYSQL_PASSWORD=thang -e MYSQL_ROOT_PASSWORD=thang mysql5.6

# Install nginx container
cd $base_dir/nginx
docker build --no-cache=true --rm=true -t nginx .
docker rm -f nginx
docker run -it -d --name nginx -p 40022:22 -p 8081:80 --link mysql5.6:db nginx