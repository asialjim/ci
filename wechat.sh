#!/bin/sh
cd
git clone git@github.com:MicroApplet/WeChat.git
cd WeChat
sh release.sh
cd
rm -rf WeChat