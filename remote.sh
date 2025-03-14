#!/bin/sh
cd
git clone git@gitee.com:micro-applet/Remote.git
cd remote
$MAVEN_HOME/bin/mvn clean install -DskipTests=true
cd
rm -rf remote