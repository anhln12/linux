[root@wap01 ~]# grep -vE '^\s*(#|$)' /etc/vsftpd/vsftpd.conf
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_file=/var/log/vsftpd.log
xferlog_std_format=NO
log_ftp_protocol=YES
ftpd_banner="FTP Server"
chroot_local_user=YES
allow_writeable_chroot=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_enable=YES
userlist_file=/etc/vsftpd/user_list
userlist_deny=NO
tcp_wrappers=YES
pasv_enable=YES
pasv_min_port=30000
pasv_max_port=31000
session_support=YES

[root@wap01 ~]# cat /etc/vsftpd/user_list
# vsftpd userlist
root
bin
daemon
adm
lp
sync
