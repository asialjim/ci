#!/bin/sh
cd
git clone git@gitee.com:micro-bank/user.git
cd user
git checkout -b feature origin/feature
$MAVEN_HOME/bin/mvn clean install -DskipTests=true
cd
rm -rf user