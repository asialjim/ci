#!/bin/sh
cd
git clone git@gitee.com:micro-applet/Remote.git
cd Remote
$MAVEN_HOME/bin/mvn clean install -DskipTests=true
cd
rm -rf Remote