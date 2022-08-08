#author 
#LastUpdate 2018-11-16

echo 1.==== check jetty running or not ===
countJ=`ps -ef | grep jetty| grep -v grep|wc -l`

if [ $countJ -eq 0 ];then
        echo === Start jetty ===
        cd /opt/jetty/jettymnp
        ./startup.sh
fi

echo 2.==== check weblogic running or not ===
countW=`ps -ef | grep weblogic| grep -v grep|wc -l`
if [ $countW -eq 0 ];then
        echo === Start weblogic ===
        cd /opt/app/Oracle/Middleware/Oracle_Home/user_projects/domains/policy_domain/bin
        ./startup.sh
fi

echo 3.==== check pushcskhpriority running or not ===
countS=`ps -ef | grep smspushpriority| grep -v grep|wc -l`
if [ $countS -eq 0 ];then
        echo === Start pushcskhpriority ===
        cd /opt/app/push_cskh_priority
        ./pushcskh.sh
fi

echo 4.==== check pushcskh running or not ===
countP=`ps -ef | grep smspush| grep -v grep|wc -l`
if [ $countP -eq 0 ];then
        echo === Start pushcskh ===
        cd /opt/app/push_cskh01
        ./pushcskh.sh
fi

echo 5.==== check tomcat443 running or not ===
countT=`ps -ef | grep tomcat443| grep -v grep|wc -l`
if [ $countT -eq 0 ];then
        echo === Start tomcat443 ===
        cd /opt/WEB/tomcat443
        ./startup.sh
fi

echo 6.==== check tomcat6666 running or not ===
count6=`ps -ef | grep tomcat6666| grep -v grep|wc -l`
if [ $count6 -eq 0 ];then
        echo === Start tomcat6666 ===
        cd /opt/WEB/tomcat6666
        ./startup.sh
fi
exit 0
