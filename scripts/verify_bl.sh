#!/bin/sh
PATH=/bin:/usr/bin:/usr/local/bin:/usr/X11R6/bin:/sbin:/usr/sbin:/usr/local/sbin
export PATH
source $HOME/.bash_profile
# Author anhln
# Email: anhle0412@gmail.com
# Shell script to monitor Gen process hang or not
echo "Filename is bl_verify.sh"
echo "Lastupdate: 2019-12-15"
###########################################################
# Some other variables here
###########################################################
date_verify_file=`date +%d_%m_%Y  -d "1 day ago"`
date_verify=`date +%d_%m_%Y`
filename_verify="BLVC_$date_verify.csv"
filename_verify_new="BLVC_$date_verify.txt"
des_path="/home/mnp"
mnp_path="/home/mnp/scripts/"
file_ex="BL_"`date +%Y%m%d  -d "0 day ago"`".csv"
file_ex_new="BL_"`date +%Y%m%d  -d "0 day ago"`".txt"

########## Config info Database ###########################
DB_UserName="xxxx"
DB_Password="xxxx"
DB_Port="1521"
DB_SERVICE_NAME="xxxx"
DB_Host="xxxx"


##########################################################
# Body scripts 
##########################################################
cd $mnp_path
echo "truncate table BL_TMP;" > myscript.sql

cp -r $des_path/$filename_verify $mnp_path/$filename_verify_new
less $filename_verify_new | grep "84" > BL_VC.txt
sed -i -e 's/ //g' BL_VC.txt
sed -i -e 's/,ALL/,18001091/g' BL_VC.txt

while read LINE
do
        MSISDN=`echo "$LINE" |awk -F',' '{print $1}'`
        SOURCE_ADD=`echo "$LINE" |awk -F',' '{print $2}'`
                KEY="BL_"$SOURCE_ADD"_"$MSISDN
        echo "insert into BL_TMP (MSISDN,CREATED_DATE,SOURCE_ADD,KEY) values ($MSISDN, SYSDATE, $SOURCE_ADD, '$KEY');" >> myscript.sql
done < BL_VC.txt
echo "commit;" >> myscript.sql
echo "delete from BL_TMP where KEY IN (Select KEY from black_list);" >> myscript.sql
echo "commit;" >> myscript.sql
echo "set linesize 4000 pagesize 0 colsep ','" >> myscript.sql
echo "set heading on feedback off verify off trimspool on trimout on" >> myscript.sql
echo "spool &1" >> myscript.sql
echo "select msisdn,source_add,key from BL_TMP;" >> myscript.sql
echo "exit;" >> myscript.sql
sed 's/\r//g' myscript.sql > myscript_new.sql

### Thuc hien chay sql de thao tac cac phan tren

sqlplus -s "$DB_UserName/$DB_Password@(DESCRIPTION =(ADDRESS = (PROTOCOL = TCP)(HOST = $DB_Host)(PORT = 1521))(CONNECT_DATA =(SERVICE_NAME = $DB_SERVICE_NAME)))" @$mnp_path/myscript_new.sql $file_ex

number_update=`less $file_ex | wc -l`
urlapi_sync="http://xxxx:8002/xxxx/api/notify/tc"
if [[ $number_update -gt 0 ]]; then
cp $file_ex $file_ex_new
sed -i -e 's/ //g' $file_ex_new

while IFS= read line
do
        msisdn=`echo "$line" |awk -F',' '{print $1}'`
        source=`echo "$line" |awk -F',' '{print $2}'`
        data='<ACCESSGW><MODULE>SMSGW_NOTIFY</MODULE><MESSAGE_TYPE>REQUEST</MESSAGE_TYPE><COMMAND><transaction_id>1234</transaction_id><msisdn>'$msisdn'</msisdn><service_number>'$source'</service_number><action>1</action> <callback_url>abc</callback_url></COMMAND></ACCESSGW>'
        echo $data > data.xml
        /usr/bin/curl -X POST -H 'Content-type: text/xml' -d @data.xml -o respone_code_api_sync.txt $urlapi_sync -w "%{response_code};%{time_total}" > respone_time_api_sync.txt
done < $file_ex_new
/usr/bin/curl -X POST "https://api.telegram.org/bot682924377:AAE5jvi0g1UlRammHViXH9A2vNwn0wL9S3E/sendMessage" -d "chat_id=-371792652&text= Da thuc hien verify BL so luong thue bao thuc hien sysnc: $number_update"
fi

exit 0