#!/bin/sh
cd
git clone git@github.com:MicroApplet/commons.git
cd commons
$MAVEN_HOME/bin/mvn clean install -DskipTests=true
cd
rm -rf commons