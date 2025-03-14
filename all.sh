#!/bin/sh
apt update && apt install -y gnupg
sh remote.sh
sh commons.sh
sh gateway.sh
sh wechat.sh
sh user.sh
