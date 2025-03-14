#!/bin/sh
cd
git clone git@github.com:MicroApplet/MAMS.git
cd MAMS
sh release.sh
cd
rm -rf MAMS