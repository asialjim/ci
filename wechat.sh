#!/bin/sh
cd
git clone git@github.com:MicroApplet/WeChat.git
cd WeChat
mvn deploy
cd
rm -rf WeChat