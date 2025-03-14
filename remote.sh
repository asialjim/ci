#!/bin/sh
cd
git clone git@github.com:MicroApplet/Remote.git
cd Remote
sh release.sh
cd
rm -rf Remote