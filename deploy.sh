#!/bin/bash
echo " killing Process"
ps -ef| grep app1.jar| grep -v grep| awk '{print $2}'| xargs kill -9
export BUILD_ID=dontKillMe
echo " running jar"
nohup java -jar ~/app1.jar > ~/applogs.log 2>&1 &
echo " Deployment Finished"
