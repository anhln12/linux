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

6. Inode
Thực hiện lệnh , để đếm và liệt kê thông số innodes của từng đường dẫn cụ thể:
find / -xdev -printf '%h\n' | sort | uniq -c | sort -k 1 -n

Ngoài ra bạn có thể sử dụng lệnh :
for i in `find . -type d `; do echo `ls -a $i | wc -l` $i; done | sort -n
hoặc

for i in /home/* `ls -1b`; do c=`find $i -type f |wc -l`; echo "$c $i"; done;


vòng lặp:
while sleep 1; do ./better-top.sh; done;
