#!/bin/sh
apt update && apt install -y gnupg
sh commons.sh
sh remote.sh
sh wechat.sh
sh mams.sh