#!/bin/sh
cd
git clone git@github.com:MicroApplet/MAMS.git
cd MAMS
$MAVEN_HOME/bin/mvn clean install -DskipTests=true
cd
rm -rf MAMS