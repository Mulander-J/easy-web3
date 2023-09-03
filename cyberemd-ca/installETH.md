# Install ETH

## FISCO-BCOS

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

## Geth

### Ethash Example

```json
{
  "config": {
    "chainId": 1008,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "berlinBlock": 0,
    "ethash": {}
  },
  "difficulty": "1",
  "gasLimit": "8000000",
  "alloc": {
    "e29015ab9131e89cA6546427A14F42371EBf1bB1": { "balance": "300000" }
  }
}
```

```bash
geth init --datadir ./data genesis.json

geth --datadir ./data --networkid 12345 --http --http.addr 0.0.0.0 --http.port 8545 --http.corsdomain "*" --http.api "db,eth,web3,miner,admin,personal,net" --port 30305 -allow-insecure-unlock console 2>>geth.log

geth --datadir ./data --networkid 1008  --http --http.addr 0.0.0.0 --http.vhosts "*" --http.api "db,net,eth,web3,personal" --http.corsdomain "*" --snapshot=false --mine --miner.threads 1 --miner.etherbase=0xE293F70740e9B21aD8599750313D891d1323CcBb
 --allow-insecure-unlock  console 2> 1.log
```

### Clique Example

```json
{
  "config": {
    "chainId": 12345,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "berlinBlock": 0,
    "clique": {
      "period": 5,
      "epoch": 30000
    }
  },
  "difficulty": "1",
  "gasLimit": "8000000",
  "extradata": "0x0000000000000000000000000000000000000000000000000000000000000000e29015ab9131e89cA6546427A14F42371EBf1bB10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  "alloc": {
    "e29015ab9131e89cA6546427A14F42371EBf1bB1": { "balance": "300000" }
  }
}
```

```bash
geth init --datadir ./data genesis.json

geth --datadir ./data --networkid 12345 --http --http.addr 0.0.0.0 --http.port 8545 --http.corsdomain "*" --http.api "db,eth,web3,miner,admin,personal,net" --port 30305 -allow-insecure-unlock console 2>>geth.log
```
