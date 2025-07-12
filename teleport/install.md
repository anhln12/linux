Cài đặt Teleport trên Ubuntu 22.04

Teleport như một Accesss Plane và Certification Authority

Bước 1. Tải về Teleport

Repository GPS Signing Key Teleport không bao gồm trong kho lưu trữ apt mặc định của Ubuntu 22.04. Do đó, bạn cần nhập khóa GPG của kho lưu trữ Teleport để cài đặt
```
sudo curl https://deb.releases.teleport.dev/teleport-pubkey.asc \ -o /usr/share/keyrings/teleport-archive-keyring.asc
```

<img width="965" height="220" alt="image" src="https://github.com/user-attachments/assets/1f0687f6-bff7-454a-9381-0c6c8df28c23" />

Bước 2: Thêm repo vào APT
```
$ echo "deb [signed-by=/usr/share/keyrings/teleport-archive-keyring.asc] https://deb.releases.teleport.dev/ stable main" \
| sudo tee /etc/apt/sources.list.d/teleport.list > /dev/null
```
![Uploading image.png…]()

Bước 3: Cập nhật kho lưu trữ apt
```
sudo apt update
```

Bước 4: Cài đặt Teleport
```
sudo apt-get install teleport
```

Bước 4: Cấu hình bảo mật

Tạo chứng chỉ SSL, chúng ta tạo chứng chỉ của mình bằng lệnh OpenSSL
```
openssl req -x509 -nodes -newkey rsa:4096 \
-keyout /var/lib/teleport/teleport.key \
-out /var/lib/teleport/teleport.pem -sha256 -days 3650 \
-subj "/C=US/ST=NewYork/L=NewYork/O=town website/OU=Org/CN=linuxhint-demo.com"
```

Tạo cấu hình Teleport
```
teleport configure -o /etc/teleport.yaml \
--cluster-name=linuxhint-demo.com \
--public-addr=teleport.linuxhint-demo.com:443 \
--cert-file=/var/lib/teleport/teleport.pem \
--key-file=/var/lib/teleport/teleport.key
```

Bật Teleport
```
systemctl enable --now teleport
systemctl status teleport
```

Tạo người dùng mới và gán vai trò
```
sudo tctl users add town --roles=editor,access
sudo tctl users add atown --roles=editor,access --logins=root,ubuntu,atown,user
```

Truy cập bảng điều khiển Web Teleport



