Triển khai mô hình sử dụng Ubuntu làm Router + NAT.

1. Mô hình hệ thống

Mô hình triển khai
```
                          INTERNET
                             |
                             |
                       103.21.150.225
                          Gateway
                             |
                      103.21.150.231/27
                           ens192
                      +-------------+
                      |  vx-dev-01  |
                      |  Router/NAT |
                      +-------------+
                           ens224
                        10.1.10.4/24
                             |
                             |
                        10.1.10.0/24
                             |
                         vx-dev-02
                     Gateway: 10.1.10.4
```

Thông tin IP
|Thiết bị| Interface|IP|GW|
|---|---|---|---|
|vx-dev-01|ens192|103.21.150.231/27|103.21.150.225|
|vx-dev-01|ens224|10.1.10.4/24|N/A|
|vx-dev-02|ens160|10.1.10.6/24|10.1.10.4|

2. Kiểm tra trên server vx-dev-01

- Kiểm tra IP
```
[root@vx-dev-01 ~]# ip addr | grep ens
2: ens192: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    inet 103.21.150.231/27 brd 103.21.150.255 scope global noprefixroute ens192
3: ens224: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    inet 10.1.10.4/24 brd 10.1.10.255 scope global noprefixroute ens224
```

- Kiểm tra ROUTE
```
[root@vx-dev-01 ~]# ip route
default via 103.21.150.225 dev ens192 proto static metric 100
10.1.10.0/24 dev ens224 proto kernel scope link src 10.1.10.4 metric 101
103.21.150.224/27 dev ens192 proto kernel scope link src 103.21.150.231 metric 100
```

- Trong đó:
```
default via 103.21.150.225 dev ens192 proto static metric 100
```

là route mặc định để vx-dev-01 đi Internet

3. Enable IPv4 forwarding

Mặc định Linux không hoạt động như router. Cần bật IPv4 forwarding

Kiểm tra:
```
sysctl net.ipv4.ip_forward
```

Nếu:
```
net.ipv4.ip_forward = 0
```

Thì bật:
```
sysctl -w net.ipv4.ip_forward=1
```

Cấu hình vĩnh viễn
```
cat > /etc/sysctl.d/99-ip-forward.conf <<'EOF'
net.ipv4.ip_forward = 1
EOF
```

Apply
```
sysctl --system
```

4. Cấu hình NAT trên vx-dev-01

Máy vx-dev-02 sử dụng IP Private: ```10.1.10.x```

Ip Private này không thể trực tiếp đi Internet

Do đó vx-dev-01 sẽ NAT:
```
    10.1.10.x
       ↓
 103.21.150.231
       ↓
   Internet
```

Thực hiện
```
iptables -t nat -A POSTROUTING \
    -s 10.1.10.0/24 \
    -o ens192 \
    -j MASQUERADE
```

Kiểm tra:
```
iptables -t nat -L POSTROUTING -n -v
```

Có thể thấy:
```
MASQUERADE  all  --  10.1.10.0/24  0.0.0.0/0
```

5. Cho phép Forward traffic

Cho phép traffic từ mạng private đi ra internet
```
iptables -A FORWARD \
    -i ens224 \
    -o ens192 \
    -s 10.1.10.0/24 \
    -j ACCEPT
```

Cho phép traffic response từ internet quay trở lại
```
iptables -A FORWARD \
    -i ens192 \
    -o ens224 \
    -d 10.1.10.0/24 \
    -m conntrack \
    --ctstate ESTABLISHED,RELATED \
    -j ACCEPT
```

Kiểm tra:
```
iptables -L FORWARD -n -v
```

Kết quả:
```
[root@vx-dev-01 ~]# iptables -L FORWARD -n -v
Chain FORWARD (policy ACCEPT 99 packets, 7062 bytes)
 pkts bytes target     prot opt in     out     source               destination
  31M   43G DOCKER-USER  all  --  *      *       0.0.0.0/0            0.0.0.0/0
  31M   43G DOCKER-FORWARD  all  --  *      *       0.0.0.0/0            0.0.0.0/0
31584 1701K ACCEPT     all  --  ens224 ens192  10.1.10.0/24         0.0.0.0/0
61879  202M ACCEPT     all  --  ens192 ens224  0.0.0.0/0            10.1.10.0/24         ctstate RELATED,ESTABLISHED
```
6. Lưu cấu hình iptables
```
iptables-save
```

7. Cấu hình Gateway trên server vx-dev-02

- Điều chỉnh gw 10.1.10.4
```
99-network.yaml
network:
    ethernets:
        ens160:
            addresses:
            - 10.1.10.6/24
            **gateway4: 10.1.10.4**
            nameservers:
                addresses: []
                search: []
    version: 2
```

- Kiểm tra ROUTE
```
ip route
default via 10.1.10.4 dev ens160 proto static
10.1.10.0/24 dev ens160 proto kernel scope link src 10.1.10.6
```

- Kiểm tra Inernet từ server vx-dev-02
```
ping -c 4 8.8.8.8
```

