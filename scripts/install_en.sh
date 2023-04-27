#!/bin/bash

set -e

# Check the operating system
OS=$(uname -s)
if [ "$OS" == "Linux" ]; then
    # Check if user is root
    if [ "$EUID" != 0 ]; then
        echo "Please run this script as root."
        exit
    fi

    # Linux-specific code here
    basedir=/usr/local/zbot
    if ! command -v nvidia-smi &> /dev/null; then
            echo "Nvidia GPU not found."
            has_nvidia_gpu=false
        else
            echo "Nvidia GPU found."
            has_nvidia_gpu=true
    fi
elif [ "$OS" == "Darwin" ]; then
    # Mac-specific code here
    basedir=$HOME/zbot
    has_nvidia_gpu=false
else
    echo "Unsupported operating system: $OS"
    exit 1
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Please install Docker and try again."
    exit 1
fi

# Check if the user has permission to execute docker.sock
if ! docker ps > /dev/null 2>&1; then
    echo "The current user does not have permission to execute docker.sock. Please make sure the user is in the docker group or has appropriate permissions."
    exit 1
fi

# Check if Docker is running
if ! docker ps > /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if the current user has Docker permissions
if ! docker info > /dev/null 2>&1; then
    echo "The current user does not have Docker permissions. Please make sure the user is in the docker group or has appropriate permissions."
    exit 1
fi

# Check if the user wants to use GPU
if $has_nvidia_gpu; then
  read -p "Do you want to use GPU (y/n)? " USE_GPU
else
  USE_GPU="no"
fi

zbot=promptai/zbot-aio:latest
ai=promptai/zbotai:release

# 1、pull docker image
docker pull $zbot
docker pull $ai

# 2、remove exist container
docker rm -f zbot

# 3、prepare dirs
mkdir -p $basedir/.promptai/
mkdir -p $basedir/logs
mkdir -p $basedir/mysql
mkdir -p $basedir/mongo
mkdir -p $basedir/p8s

# 4、bind port
hostport=9000

# 5、run container
if [ "$USE_GPU" == "y" ]; then
    echo "Run GPU version"
    # Add GPU-specific code here
    docker run --restart always --name zbot -d --add-host=host.docker.internal:host-gateway -v $basedir/.promptai/:$basedir/.promptai/:rw -v /var/run/docker.sock:/var/run/docker.sock  -v $basedir/logs:/data/logs -v $basedir/mysql:/data/mysql -v $basedir/mongo:/data/mongo -v $basedir/p8s:/data/minimalzp/p8s -e ai.base.dir=$basedir/.promptai/ -p $hostport:80 --gpus all $zbot
else
    echo "Run CPU version"
    docker run --restart always --name zbot -d --add-host=host.docker.internal:host-gateway -v $basedir/.promptai/:$basedir/.promptai/:rw -v /var/run/docker.sock:/var/run/docker.sock  -v $basedir/logs:/data/logs -v $basedir/mysql:/data/mysql -v $basedir/mongo:/data/mongo -v $basedir/p8s:/data/minimalzp/p8s -e ai.base.dir=$basedir/.promptai/ -p $hostport:80  $zbot
fi

echo "All steps finished, wait container up..."
docker logs -f zbot