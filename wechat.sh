#!/bin/sh
cd
git clone git@gitee.com:micro-applet/wechat.git
cd wechat
$MAVEN_HOME/bin/mvn clean install -DskipTests=true
cd
rm -rf wechat