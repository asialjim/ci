#!/bin/sh
cd
git clone git@github.com:MicroApplet/commons.git
cd commons
sh release.sh
cd
rm -rf commons