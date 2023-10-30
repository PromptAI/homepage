[中文](README.md) | [English](README_en.md)

<h2 align="center">PromptDialog： A No-Code Development Environment for Chatbots </h2>

PromptDialog is a no-code development environment built for fast dialogue design and deployment.  It is based on <a href="https://github.com/rasaHQ/rasa" target="_blank">RASA</a>, but does not require specific knowledge of RASA to design and deploy chatbots. PromptDialog uses natural language to design natural language dialogues.  It minimizes annotation and coding efforts,  aiming for a chatbot release in a few minutes.  PromptDialog facilitates fast debugging, allowing your team to quickly identify errors and improve your design.  The source code of developed chatbots can be downloaded for local/cloud deployment and further customization. 

<h2 name="highlights" align="center">HIGHLIGHTS</h2>

<center>
<table>
  <tr>
    <th><h3>No code programming</h3></th>
    <th><h3>All-In-One project management</h3></th>
    <th><h3>Predefined entities and intents</h3></th>
    <th><h3>Fast debugging of dialogue flows</h3></th>
  </tr>
    <tr>
    <td width="25%">You can design a dialogue system directly without knowing programming.  Our no-code dialogue editor allows you to implement complex information collection and/or business logics using fine-grained conditions and input validation. It provides automatically generated <strong><a href="https://github.com/rasaHQ/rasa" target="_blank">RASA</a></strong> codes for learning and customization.</td>
    <td width="25%">Entities, intents, slots (variables) and dialog flows are fully displayed in the same integrated development environment (IDE). Different dialogue modules can be combined at will and released with one click.  It provides Web/Mobile modes for publishing. Just copy a few lines of code to have the conversation capability in your applications. </td>
    <td width="25%">Provide various predefined entities and intents to facilitate rapid development. </td>
    <td width="25%">It is the first of its kind system that embedded software development process in dialogue system design/debugging.  Each dialogue flow can be trained separately or jointly to facilitate testing and rapid debugging.</td>
  </tr>

</table>
</center>

### Use Cases

Manual Q/A FAQs in driving

Order Bot collect fruits order information

Weather Bot query city weather

...

### Demo Video
<table border="0">
<tr>
 <td width="33%">

[Retail Starter Pack](https://www.promptai.us#examples)
 </td>
<td width="33%">

[Financial Services](https://www.promptai.us#examples)
 </td>
<td width="33%">

[IT Helpdesk Starter Pack](https://www.promptai.us#examples)
 </td>
</tr>
</table>



<h2 name="quick-start" align="center">Quick Start</h2>

Cloud version PromptAI is accessible[https://app.promptai.us](https://app.promptai.us) You can experience it after registering your account.


<h2 name="documentation" align="center">Documents</h2>

Get PromptAI Document [Document](https://doc.promptai.us/) from [https://doc.promptai.us](https://doc.promptai.us). 

<h2 name="development" align="center">Local installation</h2>

### Install
If you need to deploy the service to your own private server or local, you can refer to the following tutorial.



#### Prepare

1. The latest version of Docker is installed
2. Enough hard disk space (more than 20GB is recommended, and the current Docker image required is about 11GB)


#### Install via one CMD

Run on your machine
```text
curl -o install_en.sh 'https://cdn.githubraw.com/PromptAI/homepage/main/scripts/install_en.sh' && chmod +x install_en.sh && ./install_en.sh
```

#### Script

The installation process can be unattended. The pull image time here is related to the network. You can have a cup of tea and come back.

1. Support Linux/MacOS (if you have Windows installation requirements, you can leave us a message on the official website/WeChat group); 
2. Re-execute the script when updating, and the data has been mounted to the local directory;
3. The script may be updated later. Please pay attention。
4. The [shell script](/scripts/install_en.sh)

```shell
#!/bin/bash

set -e

HOSTNAME=$(hostname)
basedir=$HOME/zbot
zbot=promptai/zbot-aio:latest
ai=promptai/zbotai:release

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

echo "Use Port: $hostport"

# Check the operating system
OS=$(uname -s)
if [ "$OS" == "Linux" ]; then
    # Check if user is root
    if [ "$EUID" != 0 ]; then
        echo "Please run this script as root."
        exit
    fi

    # Linux-specific code here
    if ! command -v nvidia-smi &> /dev/null; then
        echo "Nvidia GPU not found."
        has_nvidia_gpu=false
    else
        echo "Nvidia GPU found."
        has_nvidia_gpu=true
        if ! command -v nvidia-container-cli --load-kmods info &>/dev/null; then
            echo -e "\033[33mNVIDIA Container Runtime needs to be installed to enable the GPU\033[0m"
            echo -e "\033[33mInstall NVIDIA Container Runtime: https://developer.nvidia.com/blog/gpu-containers-runtime/\033[0m"
            has_nvidia_container_cli=false
        else
            has_nvidia_container_cli=true
        fi
    fi
elif [ "$OS" == "Darwin" ]; then
    # Mac-specific code here
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
if $has_nvidia_gpu && $has_nvidia_container_cli; then
  read -p "Do you want to use GPU (y/n)? " USE_GPU
else
  USE_GPU="no"
fi


# 1、pull docker image
echo "Try to pull the latest docker image."
docker pull $zbot
docker pull $ai
echo "Done"

# 2、remove exist container
docker rm -f zbot

# 3、prepare dirs
mkdir -p $basedir/.promptai/
mkdir -p $basedir/logs
mkdir -p $basedir/mysql
mkdir -p $basedir/mongo
mkdir -p $basedir/p8s
mkdir -p $basedir/mount


# 4、run container
if [ "$USE_GPU" == "y" ]; then
    echo "Run GPU version"
    # Add GPU-specific code here
    docker run --restart always --name zbot -d --add-host=host.docker.internal:host-gateway -v $basedir/.promptai/:$basedir/.promptai/:rw -v /var/run/docker.sock:/var/run/docker.sock  -v $basedir/logs:/data/logs -v $basedir/mysql:/data/mysql -v $basedir/mongo:/data/mongo -v $basedir/p8s:/data/minimalzp/p8s -v $basedir/mount:/data/mount -e "HOSTNAME=$HOSTNAME" -e ai.base.dir=$basedir/.promptai/ -p $hostport:80 --gpus all $zbot
else
    echo "Run CPU version"
    docker run --restart always --name zbot -d --add-host=host.docker.internal:host-gateway -v $basedir/.promptai/:$basedir/.promptai/:rw -v /var/run/docker.sock:/var/run/docker.sock  -v $basedir/logs:/data/logs -v $basedir/mysql:/data/mysql -v $basedir/mongo:/data/mongo -v $basedir/p8s:/data/minimalzp/p8s -v $basedir/mount:/data/mount -e "HOSTNAME=$HOSTNAME" -e ai.base.dir=$basedir/.promptai/ -p $hostport:80  $zbot
fi

echo "All steps finished, wait container up..."
docker logs -f zbot
```

#### Completed
After the command is executed, we can see the address, account and password information, as shown in the figure:

```shell
# Judge whether the service is started successfully by viewing the container log
docker logs -f zbot
```
See ` System is ready` Indicates that the system is started successfully
![deploy-01](images/deploy-01.png)

#### Login experience
Open browser access` http://ip:port `You can see the effect *Assuming that the installation script is used and the port is not changed, you can access` http://localhost:9000 `Log in*

The user can start the experience by displaying the account and password after installation, as shown in the figure:
![deploy-02](images/deploy-02-en.png)

<br/>*Note: Default initial login account/password: admin@promptai.local /Promptai, but please follow the display after the service installation*

<br/>
<h2 align="center">Contact</h2>

Official Website：
[www.promptai.us](https://www.promptai.us/)

Email: info@promptai.us

<br/>
<h2 align="center">License</h2>

Free use
