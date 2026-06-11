Node 24 (MASTER) mở UFW
```
sudo ufw allow from 172.24.17.25 to any proto vrrp comment 'VRRP từ Node 25'
sudo ufw allow to 224.0.0.18 proto vrrp comment 'Keepalived Multicast'
sudo ufw allow in to any proto igmp comment 'Allow IGMP Multicast'
sudo ufw reload
```

Node 25 (BACKUP) mở UFW
```
sudo ufw allow from 172.24.17.24 to any proto vrrp comment 'VRRP từ Node 25'
sudo ufw allow to 224.0.0.18 proto vrrp comment 'Keepalived Multicast'
sudo ufw allow in to any proto igmp comment 'Allow IGMP Multicast'
sudo ufw reload
```

Trong môi trường Cloud\Virtualization (Như OpenStack, AWS, hoặc tườn lửa Multicast quá phức tạp), config Unicast chạy ổn định và bảo mật hơn rất nhiều vì các node gửi gói tin trực tiếp cho nhau qua IP gốc, không cần qua địa chỉ 224.0.0.18

Cấu hình trên Node 24 (Master): /etc/keepalived/keepalived.conf
```
vrrp_instance VI_1 {
    state MASTER
    interface ens3
    virtual_router_id 51
    priority 150
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1234
    }
    unicast_src_ip 172.24.17.24   # IP gốc của Node 24
    unicast_peer {
        172.24.17.25              # IP của Node 25
    }
    virtual_ipaddress {
        172.24.17.42/25 dev ens3
    }
}
```

Cấu hình trên Node 25 (Backup): /etc/keepalived/keepalived.conf
```
vrrp_instance VI_1 {
    state BACKUP
    interface ens3
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1234
    }
    unicast_src_ip 172.24.17.25   # IP gốc của Node 25
    unicast_peer {
        172.24.17.24              # IP của Node 24
    }
    virtual_ipaddress {
        172.24.17.42/25 dev ens3
    }
}
```
