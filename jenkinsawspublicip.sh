#!/bin/bash
# run after relaunch, send email with new public ip
#
# probably a better way to do this there is aws codepipeline & others
#
# uses make & Makefile
# pmcampbell
# ecs-cli must be installed on jenkins
# 2020-05-27

#must be a dawson email as smtp is restricted to internal addresses
email="pcampbell@dawsoncollege.qc.ca"
FN=$(date +%F-h%H-m%M).reload.container.txt

echo all:
/usr/local/bin/ecs-cli ps --cluster springbootj-fargate >/tmp/$FN

running=$(/usr/local/bin/ecs-cli ps --cluster springbootj-fargate|grep RUNNING)

ip=$(echo $running |cut -f 3 -d " "|sed s/\-\>.*//)

echo >>/tmp/$FN
echo running container: $(echo $running|cut -f 1 -d " ") >>/tmp/$FN
echo >>/tmp/$FN
echo to load the app use ip: $ip >>/tmp/$FN
echo >>/tmp/$FN
echo be aware it may take a minute to stop and start >>/tmp/$FN
echo >>/tmp/$FN
echo if you are not sure, check the aws console >>/tmp/$FN

mail -s "aws reload image" $email </tmp/$FN

