Bạn hãy tạo 1 file auto-start-services.sh sau đó bạn các đoạn mã sau vào, bạn có thể dùng vi vim nano để soạn thảo. Mình  dùng vi để soạn thảo như sau.
```
vi /bin/auto-start-services.sh
```
Sau đó dán nội dung sau vào.

Lưu ý: Bên dưới là mình thực hiện start mysqld, nếu bạn cần start các dịch vụ khác như httpd, nginx thì hãy thay vào nhé.
```
#!/bin/bash
 service=mysqld ## gán service= tên dịch vụ là mysqld

if (( $(ps -ef | awk '{ print $8 }' | grep mysqld | wc -l) > 0 )) ## Nếu kiểm tra kết quả trả về 1 thì bỏ qua, trả về 0 sẽ start lại dịch vụ
 then
 echo "$service ready running"
 else
 /etc/init.d/$service start
 fi
```
Sau khi dán vào bạn thực hiện chmod lại file
```
chmod +x /bin/auto-start-services.sh
```
Tạo crontab để tự động chạy.
Bước cuối  cùng bạn hãy tạo một cron để hệ thống tự động check, ví dụ bên dưới mình tạo cron 5 phút chạy một lần. Bạn chạy lệnh crontab -e sau đó dán vào nội dung như sau.
```
*/5 * * * * sh /bin/auto-start-services.sh
```
