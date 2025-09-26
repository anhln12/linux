Mô hình Keepalived sử dụng 2 ip vip chạy 2 node master - master để chia tải nhưng vẫn đảm bảo HA (High Availability)

1. Mô hình

| Thành Phần| Node1 | Node2|
|-----------|-------|------|
| IP Vật lý | 192.168.10.11| 192.168.10.12|
|VIP1       | 192.168.10.100 | Backup |
|VIP2       | Backup         | 192.168.10.101|

📌 Mục tiêu:
