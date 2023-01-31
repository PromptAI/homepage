#!/bin/sh
zbot=promptai/zbot-aio:latest
ai=promptai/zbotai:release

# 1、pull docker image
docker pull $zbot
docker pull $ai

docker rm -f zbot
# 2、prepare dirs
basedir=/usr/local/zbot/

mkdir -p $basedir/.promptai/
mkdir -p $basedir/logs
mkdir -p $basedir/mysql
mkdir -p $basedir/mongo
mkdir -p $basedir/p8s

# 3、bind port
hostport=9000

# GPU version
# docker run --restart always --name zbot -d --add-host=host.docker.internal:host-gateway -v /usr/local/zbot/.promptai/:/usr/local/zbot/.promptai/:rw -v /var/run/docker.sock:/var/run/docker.sock  -v $basedir/logs:/data/logs -v $basedir/mysql:/data/mysql -v $basedir/mongo:/data/mongo -v $basedir/p8s:/data/minimalzp/p8s -p $hostport:80 --gpus all $zbot
# CPU version
docker run --restart always --name zbot -d --add-host=host.docker.internal:host-gateway -v /usr/local/zbot/.promptai/:/usr/local/zbot/.promptai/:rw -v /var/run/docker.sock:/var/run/docker.sock  -v $basedir/logs:/data/logs -v $basedir/mysql:/data/mysql -v $basedir/mongo:/data/mongo -v $basedir/p8s:/data/minimalzp/p8s -p $hostport:80  $zbot
