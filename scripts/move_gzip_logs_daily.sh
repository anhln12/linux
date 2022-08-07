#!/bin/bash

date_file=`date +"%Y%m%d" -d "1 day ago"`
file_name="${date_file}_app.log"

type_log="api
backend
console"

for i in $type_log
do

if [ -f /opt/sourcecode/xxxx/${i}/runtime/logs/${file_name} ]
then
 date_logs=`date +"%Y%m%d %H:%M"`
 echo "${date_logs} file exist /opt/sourcecode/xxxx/${i}/runtime/logs/${file_name}"
 mv /opt/sourcecode/xxxx/${i}/runtime/logs/${file_name} /opt/backup/${i}/
 gzip /opt/backup/${i}/${file_name}
else
 date_logs=`date +"%Y%m%d %H:%M"`
 echo "${date_logs} file NOT exist /opt/sourcecode/xxxx/${i}/runtime/logs/${file_name}"
fi

done