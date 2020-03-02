#!/bin/bash
project="AUTOMART"
date=$(date "+%d-%b-%Y, %T")
time=$(date "+%H%M")
ip_old=$(cat IP.txt)
#echo $ip_old $time
ip=$(curl -s https://api.ipify.org)
echo $ip > IP.txt
#echo -e "=== $project ===\n$date\n$ip"
if [ $ip != $ip_old ] || [ $time = "0800" ]
then
   #msg="=== $project ===\n$date\n$ip"
   msg=$(echo -e "\n=== $project ===\n$date\nHG8245H: $ip")
   #echo $msg
   #line_noti="https://notify-api.line.me/api/notify"
   #auth_key="9JieysarjWKFMtkdo2XR23888T887iQ7zeTUrj5indS"
   curl -X POST \
        -H "Authorization: Bearer 9JieysarjWKFMtkdo2XR23888T887iQ7zeTUrj5indS" \
        -F "message=$msg" \
        https://notify-api.line.me/api/notify
fi