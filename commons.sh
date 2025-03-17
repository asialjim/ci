#!/bin/sh
cd
git clone git@github.com:MicroApplet/commons.git
cd commons
mvn deploy
cd
rm -rf commons