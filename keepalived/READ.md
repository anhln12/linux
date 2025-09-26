Mô hình Keepalived sử dụng 2 ip vip chạy 2 node master - master để chia tải nhưng vẫn đảm bảo HA (High Availability)

1. Mô hình

| Thành Phần| Node1 | Node2|
|-----------|-------|------|
| IP Vật lý | 192.168.10.11| 192.168.10.12|
|VIP1       | 192.168.10.100 | Backup |
|VIP2       | Backup         | 192.168.10.101|

📌 Mục tiêu:
- Node 1 là MASTER cho VIP1 và BACKUP cho VIP2
- Node 2 là Backup cho VIP 2 và MASTER cho VIP1
- Khi 1 node down, node còn lại sẽ đảm nhận cả VIP1 + VIP2

2. Cài đặt

2.1 Cài đặt package trên cả 2 node
```
# Ubuntu/Debian
apt update && apt install -y keepalived

# CentOS/RHEL
yum install -y keepalived
```

2.2 Cấu hình /etc/keepalived/keepalived.cof

* Node 1
```
vrrp_instance VI_1 {
    state MASTER                 # VIP1: Node1 làm MASTER
    interface eth0
    virtual_router_id 51
    priority 150                 # Ưu tiên cao hơn Node2
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1234
    }
    virtual_ipaddress {
        192.168.10.100/24 dev eth0
    }
}

vrrp_instance VI_2 {
    state BACKUP                 # VIP2: Node1 làm BACKUP
    interface eth0
    virtual_router_id 52
    priority 100                 # Ưu tiên thấp hơn Node2
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 5678
    }
    virtual_ipaddress {
        192.168.10.101/24 dev eth0
    }
}
```

* Node 2
```vrrp_instance VI_1 {
    state BACKUP                 # VIP1: Node2 làm BACKUP
    interface eth0
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1234
    }
    virtual_ipaddress {
        192.168.10.100/24 dev eth0
    }
}

vrrp_instance VI_2 {
    state MASTER                 # VIP2: Node2 làm MASTER
    interface eth0
    virtual_router_id 52
    priority 150
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 5678
    }
    virtual_ipaddress {
        192.168.10.101/24 dev eth0
    }
}
```

Chú ý:
- interface: đổi thành NIC thực tế
- virtual_router_id: Mỗi VIP phải có ID khác nhau
- auth_pass: mỗi instance có thể dùng pass khác nhau & trùng giữa 2 node

2.3 Khởi động dịch vụ
```
systemctl enable keepalived
systemctl restart keepalived
systemctl status keepalived
```

2.4 Kiểm tra
* Trên node 1
```
ip addr show eth0 | grep 192.168.10
```

- Bạn sẽ thấy:
  + VIP 1 (192.168.10.100) có trên Node 1
  + VIP 2 (192.168.10.101) không có (do Node2 giữ)
