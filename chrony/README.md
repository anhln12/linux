1. Cài đặt
```
sudo apt update
sudo apt install chrony -y
```

2. Sửa file cấu hình /etc/chrony/chrony.conf
```
pool 0.pool.ntp.org iburst
pool 1.pool.ntp.org iburst
pool 2.pool.ntp.org iburst
pool 3.pool.ntp.org iburst
```
  
4. Khởi động lại dịch vụ
```
sudo systemctl restart chrony
sudo systemctl enable chrony
```

6. Kiểm tra
```
chronyc tracking
chronyc sources -v
```

```
Giải thích thông số chính:
chronyc tracking
Reference ID : 10.255.36.150 → đây là NTP server mà client đang sync.
Stratum: 4 → máy bạn đang đồng bộ từ 1 NTP server có stratum 3 (càng thấp càng gần "gốc" GPS/atomic clock).
System time : 0.000000881 seconds fast → độ lệch hiện tại gần như bằng 0 (tốt).
Last offset : -0.002102667 seconds (~2 ms) → lệch rất nhỏ, nằm trong chuẩn.
Frequency : 12.760 ppm slow → tần số đồng hồ hệ thống được chrony hiệu chỉnh.
Skew : 3.341 ppm → sai số ước lượng, càng thấp càng tốt.
Leap status: Normal → trạng thái ổn định.

chronyc sources -v
^* trước IP 10.255.36.150 → nghĩa là đang sync chuẩn với NTP server đó.
Stratum 3 của server → nghĩa là upstream server của nó ở tầng 2 (khá gần gốc).
Last sample -68us[ -183us] +/- 95ms
offset đo được: ~183 micro giây (rất nhỏ).
sai số ước lượng: 95 mili giây (ổn định).
```
