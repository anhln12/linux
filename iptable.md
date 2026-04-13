Mặc định trên Ubuntu, iptables là một dịch vụ trạng thái nhất thời (volatile)
1. Tại sao lại như vậy
- Khi bạn gõ iptales, câu lệnh có tác dụng ngay lập tức vào Kernel của hệ điều hành.
- Tuy nhiên, Kernel không tự động ghi những nguyên tắc này vào file config
- Do đó, khi bạn reboot server, bảng quy tắc trong Kernel sẽ bị xóa sạch

2. Cách lưu vĩnh viễn
Cách 1: dùng iptable-persistent
- Gói này sẽ tạo ra 1 file tại /etc/iptables/rules.v4
```
# Cài đặt
sudo apt update && sudo apt install iptables-persistent -y

# Lưu các rule hiện tại vào file
sudo netfilter-persistent save

# Sau này nếu bạn sửa đổi iptables, nhớ chạy lại lệnh save này
```

Cách 2: Dùng ufw
