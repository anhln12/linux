LogRotate là gì, các tính năng chính?. Hướng dẫn cài đặt & cấu hình

LogRotate cung cấp nhiều tính năng quản lý file log trên hệ điều hành Linux, bao gồm:
- Xóa file log cũ: có thể xóa các file log cũ để giảm dung lượng lưu trữ.
- Nén file logs: có thể nén các file log đã quá hạn để giảm dung lượng lưu trữ
- Tùy chọn xử lý theo tần suất
- Xác định kích thước tối đa file logs

Cài đặt LogRotate đối với Ubuntu, Centos, Redhat

Ubunu
```
apt-get install logrotate
```

CentOS/RedHat
```
yum install logrotate
```

Sau khi cài đặt xong, bạn có thể sửa đổi cấu hình LogRotate tại /etc/LogRotate.conf hoặc tạo tập riêng cấu hình cho từng dịch vụ tại /etc/logrotate.d/

Thông số thường gặp trong các tệp tin của LogRotate
|Thông số| Chức năng|
|:------:|:--------:|
|daily|Mỗi này|
|weekly|Mỗi tuần|
|monthly|Mỗi tháng|
|yearly|Mỗi năm|
|missingok|Nếu file log bị mất or không có tồn tại *.log thì logrotate sẽ di chuyển tới phần cấu hình log của file log khác mà không phải xuất ra thông báo lỗi|
|nomissingok|Ngược lại so với cấu hình missingok|
|notiempty|Không rotate log nếu file log này trống|
|rotate|Số lượng file cũ đã được giữ lại sau khi rotate |
|compress|Logrotate sẽ nén tất cả các file log lại sau khi đã được rotate mặc định bằng gzip|
|compresscmd|Khi sử dụng khi không muốn file log cũ phải nén ngay sau khi vừa được rotate|
|delaycompress|Được sử dụng khi không muốn file log cũ phải nén ngay sau khi vừa được rotate|
|nocompress|Không sử dụng tính năng nén đối với file log cũ|
|create|Phân quyền cho file log mới sau khi rotate|
|copytruncate|File log cũ được sao chép vào một tệp lưu trữ, và sau đó nó xóa các dòng log cũ|
|postrotate [command] endscript|Để chạy lệnh sau khi quá trình rotate kết thúc, chúng ta đặt lệnh thực thi nằm giữa postrotate và endscript|
|prerotate [command] endscript|Để chạy lệnh trước khi quá trình rotate bắt đầu, chúng ta đặt lệnh thực thi nằm giữa prerotate và endscript|

Một số cấu hình LogRotate cơ bản

Ví dụ 1: Bạn có thể cấu hình LogRotate để rotate file log Apache mỗi ngày với kích thước tối đa là 100MB và lưu trữ 30 phiên bản cũ
```
/var/log/apache2/*.log {
    daily
    rotate 30
    size 100M
    compress
    delaycompress
    notifempty
    missingok
}
```

Ví dụ 2: Bạn có thể cấu hình LogRotate để rotate mỗi tuần:
```
/var/log/myapp.log {
    weekly
    rotate 4
    size 100M
    compress
    delaycompress
    notifempty => sẽ giữ file log nếu nó trống và không thực hiện rotate cho đến khi nó có nội dung
    missingok
}
```

Ví dụ 3: Thực thi lệnh trước hoặc sau rotate
```
/var/log/myapp.log {
    daily
    rotate 7
    size 100M
    compress
    delaycompress
    notifempty
    missingok
    create 0640 root adm
    prerotate
        /usr/bin/myapp-backup.sh
    endscript
}
```
Tùy chọn "prerotate" sẽ thực hiện lệnh "/usr/bin/myapp-backup.sh" trước khi file log được rotate. Điều này có thể giúp bạn lưu trữ bản sao của file log trước khi nó được rotate

Debug cấu hình logRotate
```
logrotate -d /etc/logrotate.conf => sử dụng -d để chạy ở trong chế độ debug
logrotate -f /etc/logrotate.conf => sử dụng -f để bất đầu rotate một file log không cần đợi đến thời gian cấu hình
logrotate -v /etc/logrotate.conf => sử dụng -v để in ra màn hình thông tin chi tiết về quá trình rotate
```



