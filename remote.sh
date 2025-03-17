#!/bin/sh
cd
git clone git@github.com:MicroApplet/Remote.git
cd Remote
mvn deploy
cd
rm -rf Remote