1. Phân quyền Linux truyền thống hoạt động thế nào?
Thông thường, Linux sử dụng 3 nhóm đối tượng:
- u (User): Chủ sở hữu file/thư mục.
- g (Group): Group sở hữu file/thư mục.
- o (Others): Những user còn lại.

Ví dụ:
```
ls -ld /data/ftpuser/data/ftpuser/data
drwxr-x---  ftpuser ftpuser  /data/ftpuser/data/ftpuser/data
```

Nếu bạn muốn cấp thêm quyền cho một group khác bằng chmod thì sẽ gặp hạn chế: chmod chỉ điều chỉnh quyền 3 nhóm u/g/o, không thể chỉ định nhiều group khác nhau so với các quyền riêng biệt

2. ACL giải quyết vấn đề gì?
ACL (Access Control List) cho phép cấp quyền chi tiết hơn cho nhiều user/group mà không cần thay đổi owner hoặc group sở hữu file.

Ví dụ:
```
drwxr-x--- ftpuser ftpuser /data/ftpuser/data/ftpuser/data
```

Bạn chạy
```
sudo setfacl -m g:2000:rx /data/ftpuser/data/ftpuser/data
```

Sau đó kiểm tra:
```
getfacl /data/ftpuser/data/ftpuser/data
```

Kết quả có thể như sau:
```
# owner: ftpuser
# group: ftpuser
user::rwx
group::r-x
group:2000:r-x
mask::r-x
other::---
```

Điểm quan trọng:
- Owner ftpuser vẫn giữ nguyên quyền rwx.
- Group sở hữu ftpuser vẫn giữ nguyên quyền r-x.
- Group GID 2000 được cấp thêm quyền r-x.
- Others vẫn không có quyền.

3. ACL khác chmod như thế nào?
|Tiêu chí|chmod/chown|ACL|
|---|---|---|
|Phân quyền owner|Có|Có|
|Phân quyền group sở hữu|Có|Có|
|Phân quyền others|Có|Có|
|Cấp quyền cho nhiều group|Không trực tiếp|Có|
|Cấp quyền riêng cho từng user|Không trực tiếp|Có|
|Giữ nguyên owner/group hiện tại khi cấp thêm quyền|Có thể|Có|
|Phân quyền chi tiết|Hạn chế|Linh hoạt|

Ví dụ thực tế:
Giả sử thư mục FTP có:
- User ftpuser quản lý dữ liệu.
- Group ftpuser có quyền đọc.
- Group 2000 là một service khác cần đọc dữ liệu.
- Các user khác không được truy cập.

ACL cho phép giải quyết việc này mà không cần thay đổi group sở hữu thư mục.

4. Cách kiểm tra trước và sau khi chạy lệnh
B1: Backup ACL hiện tại
```
getfacl -R /data/ftpuser/data/ftpuser/data > /root/ftp_acl_backup.txt
```

B2: Kiểm tra quyền hiện tại
```
getfacl /data/ftpuser/data/ftpuser/data
```

B3: Cấp quyền cho GID 2000
```
setfacl -m g:2000:rx /data/ftpuser/data/ftpuser/data
```

B4: Kiểm tra lại
```
getfacl /data/ftpuser/data/ftpuser/data
```

Bước 5: Nếu muốn khôi phục ACL đã backup
```
setfacl --restore=/root/ftp_acl_backup.txt
```




