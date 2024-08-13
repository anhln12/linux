#!/bin/bash
echo "Install rsyslog"
yum -y install rsyslog
yum -y install rsyslog || apt-get -y install rsyslog 
systemctl enable rsyslog.service || chkconfig rsyslog on
systemctl start rsyslog.service || service rsyslog start

echo "Config log History"

touch ~/.bash_profile
cp ~/{.bash_profile,.bash_profile.bk}
echo "export PROMPT_COMMAND='RETRN_VAL=$?;logger -p local6.debug \"[\$(echo \$SSH_CLIENT | cut -d\" \" -f1)] # \$(history 1 | sed \"s/^[ ]*[0-9]\+[ ]*//\" )\"'" >> ~/.bash_profile
echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >> ~/.bash_profile
touch /var/log/cmdlog.log

source ~/.bashrc_profile

echo "Config rsyslog"
mv /etc/rsyslog.{conf,conf.bk}
cat >> /etc/rsyslog.conf << EOF
\$ModLoad imuxsock
\$ModLoad imklog
\$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat
\$FileOwner root
\$FileGroup adm
\$FileCreateMode 0640
\$DirCreateMode 0755
\$Umask 0022
auth,authpriv.*-/var/log/auth.log
daemon.*-/var/log/daemon.log
kern.*-/var/log/kern.log
cron.*-/var/log/cron.log
user.*-/var/log/user.log
mail.*-/var/log/mail.log
local7.*-/var/log/boot.log
local6.*-/var/log/cmdlog.log
EOF

#END Hardening rsyslog

#Hardening Logrotate
cat > /etc/logrotate.d/syslog << EOF
/var/log/cron.log
/var/log/auth.log
/var/log/daemon.log
/var/log/maillog
/var/log/kern.log
/var/log/user.log
/var/log/mail.log
/var/log/boot.log
/var/log/debug.log
/var/log/messages
/var/log/unused.log
/var/log/cmdlog.log
{
    rotate 30
    daily
    missingok
    compress
    delaycompress
    sharedscripts
    postrotate
        /etc/init.d/rsyslog restart
    endscript
}
EOF

#END Hardening Logrotate

echo "Restart rsyslog"
systemctl restart  rsyslog.service || service rsyslog restart
source ~/.bash_profile

echo "DONE - Please logout and login"
