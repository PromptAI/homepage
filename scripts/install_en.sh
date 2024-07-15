#!/bin/bash

set -e

HOSTNAME=$(hostname)
basedir=$HOME/zbot
zbot=promptai/zbot-aio:latest
ai=promptai/zbotai:release.llm

# default port can update by -p
hostport=9000

# min & max port
min_port=1024
max_port=65535

while getopts "p:" opt; do
  case $opt in
    p)
      if [[ $OPTARG =~ ^[0-9]+$ ]]; then
        if ((OPTARG >= min_port && OPTARG <= max_port)); then
          hostport="$OPTARG"
        else
          echo "The port number must be between $min_port and $max_port" >&2
          exit 1
        fi
      else
        echo "Invalid port number: $OPTARG" >&2
        exit 1
      fi
      ;;
    \?)
      echo "Invalid option:  -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo " - $OPTARG need to be set" >&2
      exit 1
      ;;
  esac
done

# handle invalid param
shift $((OPTIND-1))

echo "Http Port: $hostport"

# Check the operating system
OS=$(uname -s)
if [ "$OS" == "Linux" ]; then
    # Check if user is root
    if [ "$EUID" != 0 ]; then
        echo "Please run this script as root."
        exit
    fi
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

# 1、pull docker image
echo "Try to pull the latest docker image."
docker pull $zbot
docker pull $ai
echo "Done"

# 2、remove exist container
docker rm -f zbot 2> /dev/null

# 3、prepare dirs
mkdir -p $basedir/.promptai/
mkdir -p $basedir/logs
mkdir -p $basedir/mysql
mkdir -p $basedir/mongo
mkdir -p $basedir/p8s
mkdir -p $basedir/mount
mkdir -p $basedir/vector

# 4、run container
docker run --restart always --name zbot -d --add-host=host.docker.internal:host-gateway -v $basedir/.promptai/:$basedir/.promptai/:rw  -v $basedir/vector:/qdrant/storage:z -v /var/run/docker.sock:/var/run/docker.sock  -v $basedir/logs:/data/logs -v $basedir/mysql:/data/mysql -v $basedir/mongo:/data/mongo -v $basedir/p8s:/data/minimalzp/p8s -v $basedir/mount:/data/mount -e "HOSTNAME=$HOSTNAME" -e "EXPOSE_PORT=$hostport"  -e ai.base.dir=$basedir/.promptai/ -p $hostport:80  $zbot

echo "All steps finished, wait container up..."
docker logs -f zbot