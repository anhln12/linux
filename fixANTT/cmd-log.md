Có 3 mảnh ghép: hook (sinh log), rsyslog (nhận log), skel (để user mới tự có hook)
Bước 1: Tạo file dòng hook (heredoc nháy đơn để tránh lỗi dấu nháy lồng nhau)
```
cat > /tmp/cmdlog.line <<'EOF'
export PROMPT_COMMAND='history -a >(logger -p local6.debug -t "$USER[$PWD] [$(echo $SSH_CLIENT | cut -d" " -f1)] ")'
EOF
```
Bước 2: Thêm vào skel (cho user tạo SAU này)
```
grep -q local6 /etc/skel/.bashrc || cat /tmp/cmdlog.line >> /etc/skel/.bashrc
```
Bước 3: Thêm cho user ĐÃ tồn tại (thay bằng danh sách user thật trên máy mới)
```
for u in user1 user2; do
  f=/home/$u/.bashrc
  grep -q local6 "$f" || cat /tmp/cmdlog.line >> "$f"
done
```
Bước 4: Phía nhận rsyslog
```
echo 'local6.*    /var/log/cmdlog.log' > /etc/rsyslog.conf
grep -n local6 /etc/rsyslog.conf     # nếu đã có dòng local6 thì bỏ một trong hai, tránh ghi đôi
systemctl restart rsyslog
```

Bước 5: Logrotate
```
cat > /etc/logrotate.d/cmdlog <<'EOF'
/var/log/cmdlog.log {
    weekly
    rotate 8
    compress
    missingok
    notifempty
    postrotate
        systemctl kill -s HUP rsyslog.service
    endscript
}
EOF
logrotate -d /etc/logrotate.d/cmdlog
```

Bước 6: Kiểm chứng bằng user thử
```
useradd -m -s /bin/bash testlog
grep -c local6 /home/testlog/.bashrc      # kỳ vọng: 1
# từ máy khác: ssh testlog@<ip>, gõ vài lệnh, rồi trên máy mới:
tail /var/log/cmdlog.log
userdel -r testlog
```



