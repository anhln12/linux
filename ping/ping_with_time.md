ping_with_time.sh
```
#!/bin/bash

# Kiểm tra xem đã nhập địa chỉ IP hoặc tên miền chưa
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <host>"
    exit 1
fi

HOST=$1

# Bắt đầu ping và ghi thời gian
while true; do
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
    PING_OUTPUT=$(ping -c 1 -W 1 "$HOST" | grep 'time=')
    if [ $? -eq 0 ]; then
        echo "[$TIMESTAMP] $PING_OUTPUT"
    else
        echo "[$TIMESTAMP] Request to $HOST failed."
    fi
    sleep 1
done
```

run scripts
```
./ping_with_time.sh <địa_chỉ_IP_hoặc_tên_miền>
```

Result
```
[2024-12-27 10:15:30] 64 bytes from 8.8.8.8: icmp_seq=1 ttl=118 time=12.3 ms
[2024-12-27 10:15:31] 64 bytes from 8.8.8.8: icmp_seq=2 ttl=118 time=12.4 ms
[2024-12-27 10:15:32] Request to 8.8.8.8 failed.
```

Exam:
```
Alert: From TEST-SMS-GW01 CLOUD CMC to FPT: Host IP
```


