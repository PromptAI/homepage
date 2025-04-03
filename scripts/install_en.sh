#!/bin/bash

# install PromptAI to Local
set -e

HOSTNAME=$(hostname)
BASE_DIR=$HOME/promptai
IMAGE=promptai/promptai:test
CONTAINER_NAME=promptai

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

echo "Use Http Port: $hostport"

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
echo "Try to pull the latest promptai docker image."
docker pull $IMAGE

echo "Done"

# 2、remove exist container
docker rm -f $CONTAINER_NAME 2> /dev/null

# 3、prepare dirs
mkdir -p $BASE_DIR/logs
mkdir -p $BASE_DIR/mysql
mkdir -p $BASE_DIR/mongo

# 4、run container
docker run --restart always \
 --name $CONTAINER_NAME -d \
 -v $BASE_DIR/logs:/data/logs \
 -v $BASE_DIR/mysql:/data/mysql \
 -v $BASE_DIR/mongo:/data/mongo \
 -v $BASE_DIR/mount:/data/mount \
 -e "HOSTNAME=$HOSTNAME" \
 -e "EXPOSE_PORT=$hostport" \
 -p $hostport:80  $IMAGE

echo "All steps finished, wait container up..."
docker logs -f $CONTAINER_NAME