#!/bin/sh
cd
git clone git@github.com:MicroApplet/WeChat.git
cd WeChat
$MAVEN_HOME/bin/mvn clean install -DskipTests=true
cd
rm -rf WeChat