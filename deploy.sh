#!/bin/bash
echo " killing Process"
ps -ef| grep app.jar| grep -v grep| awk '{print $2}'| xargs kill -9
export BUILD_ID=dontKillMe
echo " running app.jar"
nohup java -jar ~/app.jar > ~/applogs.log 2>&1 &
echo " Deployment Finished"
