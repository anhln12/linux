Tạo 1 script có đường dẫn /opt/scripts/auto-check-service.sh với nội dung như sau:

```
#!/bin/bash
SERVICE=<service>
if P=$(pgrep $SERVICE)
then
    echo "$SERVICE is running, PID is $P"
else
    echo "$SERVICE is not running, starting..."
    # start service if not running
    systemctl start $SERVICE
fi
```

Phân quyền ho scripts
```
sudo chmod +x /opt/scripts/auto-check-service.sh
```
Thiết lập Cron Job kiểm tra Service
```
* * * * * /opt/scripts/auto-check-service.sh >/dev/null 2>&1
```


