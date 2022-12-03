# Configure Floating IP with KeepAlived on CentOS 7

Configure KeepAlived on webserver-01:

yum install -y keepalived

echo "net.ipv4.ip_nonlocal_bind = 1" >> /etc/sysctl.conf

sysctl -p

cd /etc/keepalived/

mv keepalived.conf keepalived.conf.org

vi keepalived.conf

Add following directives and save.
```
! Configuration File for keepalived

global_defs {
   notification_email {
  root@webserver-01.centlinux.com
   }
   notification_email_from root@webserver-01.centlinux.com
   smtp_server 127.0.0.1
   smtp_connect_timeout 30
   router_id LVS_DEVEL
}

vrrp_instance VI_1 {
    state MASTER
    interface eno16777728
    virtual_router_id 51
    priority 101 #used in election, 101 for master & 100 for backup
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.116.50/24
    }
}
```

Start and enable keepalived service.

systemctl start keepalived

systemctl enable keepalived

Check ip Address of the server
ip addr | grep "inet" | grep "eno16777728"


Configure KeepAlived on webserver-02:

Add following directives and save
```
! Configuration File for keepalived

global_defs {
   notification_email {
  root@webserver-02.centlinux.com
   }
   notification_email_from root@webserver-02.centlinux.com
   smtp_server 127.0.0.1
   smtp_connect_timeout 30
   router_id LVS_DEVEL
}

vrrp_instance VI_1 {
    state BACKUP
    interface eno16777728
    virtual_router_id 51
    priority 100 #used in election, 101 for master & 100 for backup
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.116.50/24
    }
}
```
