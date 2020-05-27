#!/bin/bash
#default to sleep 60 seconds 
time=60s
if [[ $# -eq 1 ]] ; then
     time=$1
fi

sleep $time
echo slept $time
