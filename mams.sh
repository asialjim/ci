#!/bin/sh
cd
git clone git@gitee.com:micro-applet/MAMS.git
cd MAMS
$MAVEN_HOME/bin/mvn clean install -DskipTests=true
cd
rm -rf MAMS