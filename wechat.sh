#!/bin/sh
cd
git clone git@gitee.com:micro-bank/wechat.git
cd wechat
git checkout -b feature origin/feature
$MAVEN_HOME/bin/mvn clean install -DskipTests=true
cd
rm -rf wechat