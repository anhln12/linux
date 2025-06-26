ClamAV trên linux để scan Virus/Malware/Trojan

ClamAV là một engine mã nguồn mở chuyên dụng phát hiện trojans, virus, malware

1. Cài đặt ClamAV

Bước 1: Cài đặt dnf-ultils để hỗ trợ tải gói mà không cài đặt
```
sudo dnf install dnf-utils -y
```

Bước 2: Tạo thư mục để lưu các gói
```
mkdir clamav-offline && cd clamav-offline
```

Bước 3: Tải ClamAV & các gói dependency
```
sudo dnf download --resolve clamav clamav-update clamd
```

Bước 4: Nén thư mục lại để chuyển qua máy offline
```
cd ..
tar czvf clamav-offline.tar.gz clamav-offline
```

Bước 5: Chuyển gói sang máy Centos 8 không có internet

Bước 6: Giải nén và cài đặt trên máy offline
```
tar xzvf clamav-offline.tar.gz
cd clamav-offline
```

Bước 7: Cài đặt ClamAV
```
sudo rpm -Uvh *.rpm
```

Bước 8: Cấu hình ClamAV

* Tạo file config nếu chưa có
```
sudo cp /etc/clamd.d/scan.conf.sample /etc/clamd.d/scan.conf
sudo cp /etc/freshclam.conf.sample /etc/freshclam.conf
```

* Sửa file scan.conf
```
vi /etc/clamd.d/scan.conf
Bỏ comment dòng
LocalSocket /run/clamd.scan/clamd.sock
```

* Sửa file freshclam.conf tránh tự cập nhật
```
vi /etc/freshclam.conf
``` 

* Selinux
```
setsebool -P antivirus_can_scan_system 1
```

2. Cập nhật dữ liệu

- Vì hệ thống không có interner nên không dùng freshclam để cập nhật virus database
- Bạn có thể cập nhật thủ công tải file từ main.cvd https://database.clamav.net sau đó copy file vào thư mục /var/lib/clamav/
- Trên máy có internet
```
wget https://database.clamav.net/main.cvd
wget https://database.clamav.net/daily.cvd
```

- Scp file
```
scp main.cvd daily.cvd root@<ip>:/var/lib/clamav/
```

- Chown quyền
```
chown clamupdate:clamupdate /var/lib/clamav/*.cvd
```
3. Start clamd
```
systemctl start clamd@scan
systemctl status clamd@scan
systemctl enable clamd@scan
```

4. Scan
ClamAV có thể scan 1 hay nhiều file chỉ định
```
clamscan eicar
clamscan --recursive=yes --infected --exclude-dir='^/etc' /
clamscan -r /path
```
Chú thích:
- infected hoặc -i: chỉ in output các file bị cho là nhiễm mã độc
- recursive hoặc -r: scan cả các thư mục hay file phía trong thưc mục cha
- remove=[yes/no]
- -no-summary: không tin nội dung tổng kết
- -log=/file.log: ghi log scan vào file cụ thể
- -mv=/path: di chuyển tât cả các file bị nghi là nhiễm mã độc đến thư mục khác

5. Tải về một mẫu thử virus
```
wget -O- http://www.eicar.org/download/eicar.com.txt | clamscan -
stdin: Eicar-Test-Signature FOUND

```

6. Cấu hình cronjobs ClamAV
```
# crontab -e
0 0 * * * clamscan --recursive=yes --infected /home/
```

7. Tạo scripts scan virut

tạo script /usr/local/bin/clamav-scan.sh
```
#!/bin/bash

LOG_DIR="/var/log/clamav"
LOG_FILE="$LOG_DIR/scan-$(date +%F).log"
SCAN_DIR="/home"  # Đổi thành thư mục bạn muốn quét

mkdir -p "$LOG_DIR"

echo "===== ClamAV Scan started at $(date) =====" >> "$LOG_FILE"
clamscan -r -i "$SCAN_DIR" >> "$LOG_FILE"
echo "===== ClamAV Scan ended at $(date) =====" >> "$LOG_FILE"
```
chmod +x /usr/local/bin/clamav-scan.sh

0 1 * * * /usr/local/bin/clamav-scan.sh

Scan full server
```
sudo clamdscan --multiscan --fdpass --exclude-dir="^/sys|^/proc|^/dev|^/run|^/mnt|^/media|^/snap" / > /var/log/clamav/fullscan-$(date +%F).log
```
script đang chạy
```
[root@ ~]# cat /usr/local/bin/clamscan-telegram.sh
cat: sh: No such file or directory
#!/bin/bash

# Set up variables

NOTIFY_CHAT_ID="-973615602"
BOT_TOKEN=""
SCAN_DIR="/*"

# Update virus definitions

sudo freshclam

# Perform virus scan

result=$(sudo clamscan -r $SCAN_DIR --infected)

# Check if virus is found

a=$(echo "$result" | grep "Infected files: 0");
if [[ "$a" == ""  ]]; then
# Send notification to Telegram
message="🦠Virus found on $HOSTNAME!🧪🛡️
$result"

# infected_files=$(echo "$result" | grep -oP '(?<=Infected files: ).*' | tr -d '\r' | tr '\n' ' ')
for file in $infected_files; do
    if [[ "$file" != "" ]]; then
        dir=$(dirname "$file")
        message="$message
    $file File Bị Nhiễm $dir"
    fi
done
curl -s -X POST <https://api.telegram.org/bot$BOT_TOKEN/sendMessage> -d chat_id=$NOTIFY_CHAT_ID -d text="$message"
fi
```
