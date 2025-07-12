Cài đặt Teleport trên Ubuntu 22.04

Teleport như một Accesss Plane và Certification Authority

Bước 1. Tải về Teleport

Repository GPS Signing Key Teleport không bao gồm trong kho lưu trữ apt mặc định của Ubuntu 22.04. Do đó, bạn cần nhập khóa GPG của kho lưu trữ Teleport để cài đặt
```
sudo curl https://deb.releases.teleport.dev/teleport-pubkey.asc \ -o /usr/share/keyrings/teleport-archive-keyring.asc
```

![Uploading image.png…]()


