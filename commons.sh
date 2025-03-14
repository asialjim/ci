#!/bin/sh
cd
git clone git@gitee.com:micro-applet/commons.git
cd commons
$MAVEN_HOME/bin/mvn clean install -DskipTests=true
cd
rm -rf commons