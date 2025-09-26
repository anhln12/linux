1. Kịch bản:
- Kiểm tra ProxySQL (hoặc Mysql) còn hoạt động
- Nếu proxysql chết -> hạ priority của node -> node còn lại nhận VIP
- Sử dụng 2 VIP (Master - Master)

2. Mô hình
|Thành phần |	Node1	| Node2 |
|-----------|-----------|-----------|
|IP vật lý	| 192.168.10.11	| 192.168.10.12 |
|VIP1	| 192.168.10.100 |	(Backup) |
|VIP2	| (Backup)	| 192.168.10.101 |
|ProxySQL | port	| 6033 |	6033 |

3. Scripts check ProxySQL

Tạo file /usr/local/bin/check_proxysql.sh trên cả 2 node
```
#!/bin/bash
# Kiểm tra ProxySQL TCP port (6033) hoặc process
HOST="127.0.0.1"
PORT=6033

if nc -z -w2 $HOST $PORT >/dev/null 2>&1; then
    # ProxySQL OK
    exit 0
else
    # ProxySQL lỗi
    exit 1
fi
```

Cấp quyền thực thi:
```
chmod +x /usr/local/bin/check_proxysql.sh
```

5. Cấu hình Keepalived

Tạo file /etc/keepalived/keepalived.conf trên Node1:
```
vrrp_script chk_proxysql {
    script "/usr/local/bin/check_proxysql.sh"
    interval 2           # Kiểm tra mỗi 2s
    fall 2               # Sau 2 lần fail liên tiếp => giảm weight
    rise 2               # Sau 2 lần OK => tăng lại
    weight -20           # Giảm priority khi fail
}

# VIP1: Node1 MASTER
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 150
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass vip1pass
    }
    virtual_ipaddress {
        192.168.10.100/24 dev eth0
    }
    track_script {
        chk_proxysql
    }
}

# VIP2: Node1 BACKUP
vrrp_instance VI_2 {
    state BACKUP
    interface eth0
    virtual_router_id 52
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass vip2pass
    }
    virtual_ipaddress {
        192.168.10.101/24 dev eth0
    }
    track_script {
        chk_proxysql
    }
}
```

Node2 (/etc/keepalived/keepalived.conf):
```
vrrp_script chk_proxysql {
    script "/usr/local/bin/check_proxysql.sh"
    interval 2
    fall 2
    rise 2
    weight -20 # Giảm 20
}

# VIP1: Node2 BACKUP
vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass vip1pass
    }
    virtual_ipaddress {
        192.168.10.100/24 dev eth0
    }
    track_script {
        chk_proxysql
    }
}

# VIP2: Node2 MASTER
vrrp_instance VI_2 {
    state MASTER
    interface eth0
    virtual_router_id 52
    priority 150
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass vip2pass
    }
    virtual_ipaddress {
        192.168.10.101/24 dev eth0
    }
    track_script {
        chk_proxysql
    }
}
```

Giải thích:
- track_script: liên kết với scrip check ProxySQL
- Khi scripts trả về exit 1 -> priority giảm 20 -> node kia tiếp nhận VIP

6. Khởi động lại dịch vụ
```
systemctl enable keepalived
systemctl restart keepalived
systemctl status keepalived
```

7. Kiểm tra
- Giả lập ProxySQL chết
```
systemctl stop proxysql
```
- VIP của node đó sẽ mất 2~4s để chuyển sang node còn lại
```
ip addr show eth0 | grep 192.168.100
```

