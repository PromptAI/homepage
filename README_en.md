[中文](README.md) | [English](README_en.md)

<h2 align="center">What is PromptAI ？</h2>

In view of the engineering experience of RASA, we will simplify and contribute to the community. We will release the brain map codeless programming tool based on RASA exclusively in the world. Whether you are familiar with RASA or not, you can realize the dialogue system in a very simple way, complete a dialogue design in a few minutes, and go online. You can also download the generated RASA file for private deployment for free.
<br/>
<h2 name="highlights" align="center">Highlights</h2>

<center>
<table>
  <tr>
    <th><h2>🆒</h2><h3>No code programming</h3></th>
    <th><h2>🎓</h2><h3>Whole project management</h3></th>
    <th><h2>💻</h2><h3>Open predefined</h3></th>
    <th><h2>🚀</h2><h3>Fast debugging of modules</h3></th>
  </tr>
    <tr>
    <td width="25%">Whether you understand <strong><a href="https://github.com/rasaHQ/rasa" target="_blank">Rasa</a></strong> or not, you can start quickly. Provide RASA code download for further learning and mastering RASA</td>
    <td width="25%">The entity, intention, slot (variable) and dialog flow diagram are fully displayed in the same integrated development environment (IDE). Different dialogue modules can be combined at will and released with one button. It is the first time to combine software development process with dialog system design/debugging.</td>
    <td width="25%">Provide various predefined entities, intentions, and share all that can be shared to facilitate rapid development. We also welcome you to provide shared modules and contact us.</td>
    <td width="25%">Each parting module can be compiled separately or jointly to facilitate testing and rapid debugging</td>
  </tr>

</table>
</center>

<br/>
<h2 name="features" align="center">Features</h2>
<table>

<tr>
    <td width="33%"><h4>Visual dialog editor</h4></td>
    <td width="67%">Design and implement your conversation now</Br>Create a natural dialogue flow in our interface based on intuitive dialogue. Add natural language examples dynamically, and create rich responses using buttons, images, and merry-go-rounds. Let engineers focus on systems and integration.</td>
</tr>
<tr>
    <td width="33%"><h4>Session Form</h4></td>
    <td width="67%">Create complex session forms</Br>
Whether you want to collect information or prepare to call, our non-code flow editor allows you to implement complex business logic using fine-grained conditions and user input validation.</td>
<tr>
    <td width="33%"><h4>Customized</h4></td>
    <td width="67%">Compile and debug easily</br>We provide different debugging schemes to meet different business needs.</td>
</tr>
<tr>
    <td width="33%"><h4>Non-intrusive deployment</h4></td>
    <td width="67%">One-click easy release </Br> We provide Web/Mobile mode for publishing, without modifying any business code, and automatically generate reference code after successful publishing. Just copy a few lines of code to your application to have conversation ability.
</tr>
</table>
<br/>

<h2 name="quick-start" align="center">Examples</h2>

<table border="0">
<tr>
 <td width="33%">

[![Product example](images/example-product.png)](https://www.promptai.cn)
 </td>
<td width="33%">

[![Example of provident fund](images/example-service.png)](https://www.promptai.cn)
 </td>
<td width="33%">

[![On-board example](images/example-car.png)](https://www.promptai.cn)
 </td>
</tr>
</table>
<h2 name="quick-start" align="center">
Code scanning experience

![example-qr](images/example-qr.png)



</h2>




<h2 name="quick-start" align="center">Quick Start</h2>

Cloud version PromptAI is accessible[https://app.promptai.cn](https://app.promptai.cn) You can experience it after registering your account.


<h2 name="documentation" align="center">Documents</h2>

Get PromptAI Document [Document](https://doc.promptai.cn/) from [https://doc.promptai.cn](https://https://doc.promptai.cn). 

<h2 name="development" align="center">Local installation</h2>

### Install
If you need to deploy the service to your own private server or local, you can refer to the following tutorial.



#### Prepare

1. The latest version of Docker is installed
2. Enough hard disk space (more than 20GB is recommended, and the current Docker image required is about 11GB)
3. Internet (if not supported, you can export Docker Image on a machine with a network)

#### Script

The installation process can be unattended. The pull image time here is related to the network. You can have a cup of tea and come back.

1. Support Linux/MacOS (if you have Windows installation requirements, you can leave us a message on the official website/WeChat group); 
2. Re-execute the script when updating, and the data has been mounted to the local directory;
3. The script may be updated later. Please pay attention。

```shell
#!/bin/sh
zbot=registry.cn-hangzhou.aliyuncs.com/promptai/zbot-aio:latest
ai=registry.cn-hangzhou.aliyuncs.com/promptai/zbotai:release 

# 1、pull docker image
docker pull $zbot
docker pull $ai

# 2、remove old container
docker rm -f zbot

# 3、prepare dirs
basedir=/usr/local/zbot/

mkdir -p $basedir/.promptai/
mkdir -p $basedir/logs
mkdir -p $basedir/mysql
mkdir -p $basedir/mongo
mkdir -p $basedir/p8s

# 4、bind port
hostport=9000

# 5、run container
# GPU version 
# docker run --restart always --name zbot -d --add-host=host.docker.internal:host-gateway -v /usr/local/zbot/.promptai/:/usr/local/zbot/.promptai/:rw -v /var/run/docker.sock:/var/run/docker.sock  -v $basedir/logs:/data/logs -v $basedir/mysql:/data/mysql -v $basedir/mongo:/data/mongo -v $basedir/p8s:/data/minimalzp/p8s -p $hostport:80 --gpus all $zbot
# CPU version
docker run --restart always --name zbot -d --add-host=host.docker.internal:host-gateway -v /usr/local/zbot/.promptai/:/usr/local/zbot/.promptai/:rw -v /var/run/docker.sock:/var/run/docker.sock  -v $basedir/logs:/data/logs -v $basedir/mysql:/data/mysql -v $basedir/mongo:/data/mongo -v $basedir/p8s:/data/minimalzp/p8s -p $hostport:80  $zbot
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
![deploy-02](images/deploy-02.png)

<br/>*Note: Default initial login account/password: admin@promptai.local /Promptai, but please follow the display after the service installation*

<br/>
<h2 align="center">Contact</h2>

Official Website：
[www.promptai.cn](https://www.promptai.cn/)

Email: info@promptai.cn

<br/>
<h2 align="center">Licence</h2>

Free use