#!/bin/sh
cd
git clone git@github.com:MicroApplet/Remote.git
cd Remote
$MAVEN_HOME/bin/mvn clean install -DskipTests=true
cd
rm -rf Remote