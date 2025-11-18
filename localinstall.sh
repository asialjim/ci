#!/bin/sh
cd ../commons
mvn clean install

cd ../Remote
mvn clean install



cd ../WeChat
mvn clean install



cd ../MAMS
mvn clean install



cd ../clinc-api
mvn clean install



cd ../Tiktok
mvn clean install



cd ../Gateway
mvn clean install
