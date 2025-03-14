#!/bin/sh
cd
git clone git@gitee.com:micro-applet/commons.git
cd commons
git checkout -b feature origin/feature
$MAVEN_HOME/bin/mvn clean install -DskipTests=true
cd
rm -rf commons