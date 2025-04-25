#!/bin/sh
#
# Copyright 2014-2025 <a href="mailto:asialjim@qq.com">Asial Jim</a>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
ifconfig
docker run -it --rm -e REPO=git@github.com:MicroApplet/commons.git -e CMD=install -v /home/asialjim/.ssh:/root/.ssh  -v /home/asialjim/.m2:/root/.m2  asialjim/maven-with-gpg:jdk8
docker run -it --rm -e REPO=git@github.com:MicroApplet/Remote.git -e CMD=install -v /home/asialjim/.ssh:/root/.ssh  -v /home/asialjim/.m2:/root/.m2  asialjim/maven-with-gpg:jdk8
docker run -it --rm -e REPO=git@github.com:MicroApplet/WeChat.git -e CMD=install -v /home/asialjim/.ssh:/root/.ssh  -v /home/asialjim/.m2:/root/.m2  asialjim/maven-with-gpg:jdk8
docker run -it --rm -e REPO=git@github.com:MicroApplet/MAMS.git -e CMD=install -v /home/asialjim/.ssh:/root/.ssh  -v /home/asialjim/.m2:/root/.m2  asialjim/maven-with-gpg:jdk8

#sh commons.sh
#sh remote.sh
#sh wechat.sh
#sh mams.sh