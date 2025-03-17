#!/bin/sh
cd
git clone git@github.com:MicroApplet/MAMS.git
cd MAMS
mvn deploy
cd
rm -rf MAMS