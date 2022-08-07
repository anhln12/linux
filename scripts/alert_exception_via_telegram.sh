#!/bin/bash
PATH=/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin:/sbin:/usr/sbin:/usr/local/sbin
export PATH
# Author Anhln
# Email: anhle0412@gmail.com
# Shell script to monitor Too many open files
echo "Filename is  alert_exception_mt.sh"
echo "Lastupdate: 2019-09-20"
###########################################################
# Some other variables here
###########################################################
IP_monitor="xxxx"
logfile="/opt/crosssale/sourcecode/topup_process/smpp/logs/error/error.log"
grep_prams="Unable to cleanly return response PDU"
Monitor="SMPP"
path='/root/scripts'
today=`date +%Y-%m-%d`
currTime=`date +"%Y-%m-%d %H:%M:%S"`
currentDate=`date +%s`
##########################################################
# All Script Functions Goes Here
##########################################################

cd $path
cat $logfile | grep "Unable to cleanly return response PDU" | wc -l >> $path/logs/alert_exception_mt.$today
hientai=`tail -1 $path/logs/alert_exception_mt.\$today`
truocdo=`tail -2 $path/logs/alert_exception_mt.\$today | head -1`

message="$Monitor tren server $IP_monitor bi loi $grep_prams, thoi diem: $currTime, LOI NGHIEM TRONG, Admin xu ly ngay"

[ "$hientai" -gt "$truocdo" ] && /usr/bin/curl -X POST "https://api.telegram.org/bot682924377:/sendMessage" -d "chat_id=-xxxx&text= $message"

exit 0