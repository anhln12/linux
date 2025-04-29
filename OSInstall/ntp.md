# NTP
[Internet NTP Servers]

         |
         
   (Đồng bộ)
   
         ↓
         
[NTP Server nội bộ (192.168.1.10)]

         |
         
    (Client đồng bộ)
    
         ↓
         
[Client 1][Client 2][Client 3]

1. Cài đặt NTP Server Centos 7
```
yum install ntp -y
systemctl enable ntpd
systemctl start ntpd
```
2. Cấu hình file /etc/ntp.conf
```
vi /etc/ntp.conf

# Thêm dòng dưới để NTP server tự lấy từ internet
server 0.centos.pool.ntp.org iburst
server 1.centos.pool.ntp.org iburst
server 2.centos.pool.ntp.org iburst
server 3.centos.pool.ntp.org iburst

# Cho phép client truy cập
restrict 192.168.1.0 mask 255.255.255.0 nomodify notrap
```
3. Mở firewall cho NTP UDP Port 123
```
firewall-cmd --permanent --add-service=ntp
firewall-cmd --reload
```
4. Cài đặt NTP Client dùng ntpdate trên Centos 7
```
yum install ntpdate -y
ntpdate -u 192.168.1.10
Giải thích:
-u: dùng UDP giao tiếp (an toàn qua firewall NAT).
192.168.1.10: IP máy chủ NTP.
```
5. Thiết lập ntp với cron
```
*/5 * * * * /usr/sbin/ntpdate -u 192.168.1.10
```

6. Trên server kiểm tra kết quả
```
ntpq -p
=> Hiển thị các server đang đồng bộ
```

