<!--[中文](README.md) | [English](README_en.md) -->

<h2 align="center">PromptDialog： 基于脑图的对话机器人开发环境</h2>

PromptDialog 是为快速对话设计和部署而构建的无代码开发环境。它基于RASA，但又不需要特定的RASA 知识来设计和部署聊天机器人。 PromptDialog 使用自然语言来设计自然语言对话。它最大限度地减少了标注和编码工作，旨在几分钟内发布企业聊天机器人。 PromptDialog能使您的设计团队快速识别对话错误并改进您的设计。您也可免费下载生成的RASA源码文件， 私有部署。

<br/>
<h2 name="Highlights" align="center">Highlights</h2>

<center>
<table>
  <tr>
    <th><h3>无代码编程</h3></th>
    <th><h3>全项目管理</h3></th>
    <th><h3>开放预定义</h3></th>
    <th><h3>分模块快速调试</h3></th>
  </tr>
    <tr>
    <td width="25%">我们的可视化对话编辑环境不管您是否理解<strong><a href="https://github.com/rasaHQ/rasa" target="_blank">RASA</a></strong>， 都可快速上手。同时允许您使用细粒度条件和用户输入验证实现复杂的业务逻辑。 在发布成功后自动生成RASA代码，提供开源代码下载，方便进一步学习和掌握RASA</td>
    <td width="25%">实体， 意图， 槽位（变量），对话流图， 在同一个集成开发环境 （IDE) 中完整展示。可组合不同对话模块， 一键发布。提供 Web / Mobile 等方式进行无侵入发布，无需修改业务代码，只需将数行代码拷贝到您的应用即可拥有对话能力。 </td>
    <td width="25%">提供各种预定义实体，意图，减少用户标注数据量， 方便快速开发。</td>
    <td width="25%">首次将软件开发流程和对话系统设计/调试相结合。各模块可单独编译也可联合编译， 方便测试， 快速调试。  </td>
  </tr>

</table>
</center>

<br/>


### 案例

[车载助手](/examples/car/car.md) 行车中常见的问答

[水果订单助手](/examples/fruits/fruits.md) 收集水果下单信息

[天气查询助手](/examples/weather/weather.md) 查询城市天气

### 视频示例
<table border="0">
<tr>
 <td width="33%">

[![商品示例](images/example-product.png)](https://www.promptai.cn/zh/#examples)
 </td>
<td width="33%">

[![公积金示例](images/example-service.png)](https://www.promptai.cn/zh/#examples)
 </td>
<td width="33%">

[![车载示例](images/example-car.png)](https://www.promptai.cn/zh/#examples)
 </td>
</tr>
</table>

<h2 name="quick-start" align="center">快速开始</h2>

云版本PromptAI可访问[https://app.promptai.cn](https://app.promptai.cn) 在注册账号后即可体验。


<h2 name="documentation" align="center">帮助文档</h2>

获取PromptAI[官方文档](https://doc.promptai.cn/) 可访问  [https://doc.promptai.cn](https://doc.promptai.cn). 

<h2 name="development" align="center">本地版安装</h2>

### 安装
如果你需要将服务部署到自己的私有服务器或者本地，可以参考如下教程。

#### 准备

1. 已安装最近版本的Docker
2. 足够的硬盘空间 (建议20GB以上，目前所需Docker镜像约为11GB)

#### 一键安装


```text
curl -o install.sh 'https://cdn.githubraw.com/PromptAI/homepage/main/scripts/install_zh.sh' && chmod +x install.sh && ./install.sh
```

如采用此命令安装，无需查看后续安装教程。
- 支持自定义端口，在末尾加上：` -p <your port>`

#### 脚本

安装过程可无人值守，这里pull image耗时与网络有关，可以喝杯茶再来。

1. 支持Linux/MacOS (如果你有Windows安装需求，可以在官网/微信群给我们留言)； 
2. 更新时重新执行该脚本即可，数据已挂载到本地目录；
3. 后期可能更新该脚本，敬请注意关注。
4. [shell 脚本](/scripts/install_zh.sh)

```shell
#!/bin/bash

set -e

HOSTNAME=$(hostname)
basedir=$HOME/zbot
zbot=registry.cn-hangzhou.aliyuncs.com/promptai/zbot-aio:release
ai=registry.cn-hangzhou.aliyuncs.com/promptai/zbotai:release

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

#### 安装完成
命令执行完成后，我们可以看到地址、账号、密码信息，如图所示：

```shell
# 通过查看容器的日志，判断服务是否启动成功
docker logs -f zbot
```
看到`System is ready!`则表示系统启动成功
![deploy-01](images/deploy-01.png)

#### 登录体验
打开浏览器访问`http://ip:port`即可看到效果。*假设使用安装脚本且未更改端口，可访问`http://localhost:9000`进行登录*

使用安装完成后显示账号、密码即可开启体验，如图所示：
![deploy-02](images/deploy-02.png)

<br/>*备注：默认的初始登录账号/密码:admin@promptai.local/promptai，但是请以服务安装完成后的显示为准*

<br/>
<h2 align="center">联系我们</h2>

官网：
[www.promptai.cn](https://www.promptai.cn/)

邮箱：info@promptai.cn

<br/>
<h2 align="center">许可</h2>

免费使用
