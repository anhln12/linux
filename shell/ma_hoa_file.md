Để mã hóa file log của Nginx bạn có thể sử dụng công cụ openssl, mã hóa file bằng thuật toán AES.

1. Mã hóa file
```
encrypt.sh
#!/bin/bash

# Đường dẫn file cần mã hóa
INPUT_FILE="access.log"
OUTPUT_FILE="access.log.enc"
PASSWORD="your_strong_password"

# Mã hóa file bằng AES-256-CBC
openssl enc -aes-256-cbc -salt -in "$INPUT_FILE" -out "$OUTPUT_FILE" -pass pass:"$PASSWORD"

echo "File đã được mã hóa thành: $OUTPUT_FILE"
```

2. Giải mã file
```
decrypt.sh
#!/bin/bash

# Đường dẫn file mã hóa và file output
INPUT_FILE="access.log.enc"
OUTPUT_FILE="access.log.dec"
PASSWORD="your_strong_password"

# Giải mã file bằng AES-256-CBC
openssl enc -d -aes-256-cbc -in "$INPUT_FILE" -out "$OUTPUT_FILE" -pass pass:"$PASSWORD"

echo "File đã được giải mã thành: $OUTPUT_FILE"
```

Ghi chú:
- openssl enc -aes-256-cbc: Sử dụng thuật toán AES với khóa 256 bit ở chế độ CBC
- salt: Tăng cường bảo mật
- pass: Chỉ định mật khẩu để tạo khóa mã hóa
=> Để tránh lưu mật khẩu trực tiếp trong scripts, sử dụng biến môi trường để an toàn
PASSWORD=$MY_SECRET_PASSWORD


