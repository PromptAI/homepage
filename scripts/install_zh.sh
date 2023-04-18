#!/bin/sh
zbot=registry.cn-hangzhou.aliyuncs.com/promptai/zbot-aio:latest
ai=registry.cn-hangzhou.aliyuncs.com/promptai/zbotai:release

# 1、pull docker image
docker pull $zbot
docker pull $ai

# 2、remove old container
docker rm -f zbot

# 3、prepare dirs
if [[ $(uname) == "Darwin" ]]; then
  basedir=$HOME/zbot
else
  basedir=/usr/local/zbot
fi

mkdir -p $basedir/.promptai/
mkdir -p $basedir/logs
mkdir -p $basedir/mysql
mkdir -p $basedir/mongo
mkdir -p $basedir/p8s

# 4、bind port
hostport=9000

# 5、run container
# GPU version
# docker run --restart always --name zbot -d --add-host=host.docker.internal:host-gateway -v $basedir/.promptai/:$basedir/.promptai/:rw -v /var/run/docker.sock:/var/run/docker.sock  -v $basedir/logs:/data/logs -v $basedir/mysql:/data/mysql -v $basedir/mongo:/data/mongo -v $basedir/p8s:/data/minimalzp/p8s -e ai.base.dir=$basedir/.promptai/ -p $hostport:80 --gpus all $zbot
# CPU version
docker run --restart always --name zbot -d --add-host=host.docker.internal:host-gateway -v $basedir/.promptai/:$basedir/.promptai/:rw -v /var/run/docker.sock:/var/run/docker.sock  -v $basedir/logs:/data/logs -v $basedir/mysql:/data/mysql -v $basedir/mongo:/data/mongo -v $basedir/p8s:/data/minimalzp/p8s -e ai.base.dir=$basedir/.promptai/ -p $hostport:80  $zbot