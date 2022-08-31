# linux

1. Lệnh mount gộp các phân vùng ổ cứng
mhddfs /data01,/data02,/data03,/data04,/data05,/data06,/data07,/data08,/data09,/data10,/volume1,/volume2,/storage01 /storage -o allow_other

2. Change hostname
hostnamectl set-hostname aln-rancher

3. Tạo SSH key và cấu hình kết nối SSH
ssh-keygen
ssh-copy-id aln-master1 

4. Enable sudo NOPASSWD
myuser ALL=(ALL) NOPASSWD: ALL for a single user
%sudo  ALL=(ALL) NOPASSWD: ALL for a group

5. Cron xóa các File Backup cũ và chỉ giữ lại 7 bản backup gần nhất. Thời gian cron chạy vào lúc 02:00 sáng hàng ngày
find /home/backup -type d -mtime +7 -exec rm -rf {}
