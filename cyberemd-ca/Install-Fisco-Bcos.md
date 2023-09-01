# FISCO-BCOS

## Node

```bash
# dep
sudo apt install -y curl openssl wget
# get build.sh
curl -#LO https://github.com/FISCO-BCOS/FISCO-BCOS/releases/download/v3.4.0/build_chain.sh
# chmod
chmod u+x build_chain.sh
# build chain 
# set 127.0.0.0.1:1 as one node
build_chain.sh -l 127.0.0.1:4 -p 30300,20200
# start
nodes/127.0.0.1/start_all.sh
# stop
nodes/127.0.0.1/stop_all.sh
# check process
ps aux |grep -v grep |grep fisco-bcos
# check log
tail -f nodes/127.0.0.1/node0/log/* |grep -i "heartBeat,connected count"
```

## WeBaseFront

```bash
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
CLASSPATH=$JAVA_HOME/lib
PATH=$JAVA_HOME/bin:$PATH
export PATH JAVA_HOME CLASSPATH
```

```bash
# get java
sudo apt update sudo apt install openjdk-11-jdk
# get gradle
wget https://services.gradle.org/distributions/gradle-6.4.1-bin.zip -P /tmp
sudo unzip -d /opt/gradle /tmp/gradle-*.zip
# source
export GRADLE_HOME=/opt/gradle/gradle-6.4.1 
export PATH=${GRADLE_HOME}/bin:${PATH}
# test gradle
gradle -v
# gradle build
gradle build -x test
# cp conf
cp -r conf_template conf
# cp crt
cp ~/fisco/node/${ip}}/sdk/* /conf
# start
bash start.sh
# Front
http://localhost:5002/WeBASE-Front
```

## Python-SDK

```bash
# clone repo
git clone https://github.com/FISCO-BCOS/python-sdk
# init ENV
bash init_env.sh -p
```