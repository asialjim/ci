#!/bin/sh
cd
git clone git@gitee.com:micro-bank/remote.git
cd remote
git checkout -b feature origin/feature
$MAVEN_HOME/bin/mvn clean install -DskipTests=true
cd
rm -rf remote