#!/bin/bash
#

# 运行服务的用户,不可使用已经存在的用户名
SDHUSER="sdhuser"
# 所有程序的安装根路径
INSTALL_ROOT="/usr/local"
# local project path
LOCAL_PROJECT="senseware"
# web项目的父目录绝对路径
WEB_ROOT="/home/${SDHUSER}/web"
# web项目相对根路径的相对路径
WEB="react/single"
# web server监听的端口
WEB_PORT=3092
# 后端项目的父目录绝对路径
BACKEND_ROOT="/home/${SDHUSER}/backend"
# 后端项目相对根路径的相对路径
BACKEND="mongo notification"
# backend server的监听端口
BACKEND_PORT=3082
# 从哪个git branch 拉取最新代码
GIT_BRANCH=newDonghuan
# mongodb服务的监听端口
MONGODB_PORT="27017"

# config file path
CONSTANTSJS=/root/script/senseware/react/single/src/general/js/Constants.js
WEBJS=/root/script/senseware/react/single/web.js
CONFIGINI=/root/script/senseware/mongo/core_manager/mongo_manager/config.ini
CONFIGPY=/root/script/senseware/mongo/core_manager/mongo_manager/config.py
RUNPY=/root/script/senseware/mongo/run.py

# Constants.js file
NVRURL="//122.224.116.44:3001"
DATAWAREHOUSE="//10.52.14.189:8088"
# constants.js中新添的两行内容，第一行用于第二台web server和backend server， 第二行用于nginx server
CONSTANTSJS_NEW_LINE=" '10.52.14.188': 'http://10.52.14.188:3082',"

# config.ini file
# config.ini中新添的字段
MONGO_CLUSTER=MONGO_NODE2
MONGO_CLUSTER_NEW_LINE="[${MONGO_CLUSTER}]\nHOST=172.21.8.112\nUSER=sdhuser\nPASS=kd123456\nDB=sdh\n"
URL_FOR_C_INTERFACE="http://172.21.8.128:8080/activeInterface"

# config.py file 
MONGO=SDH

# mongodb config
MONGO_USER="sdhuser"
MONGO_PASS="Senseware2017)$)!"
MONGO_DB="sdh"
