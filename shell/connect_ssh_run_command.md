Kết nối SSH và chạy command

Đoạn script bên dưới, thực hiện kết nối ssh tới remote server chạy lệnh "uptime".
```
#!/usr/bin/env bash
# Define variables
HOST=vinasupport.com
USER=root
PORT=22
COMMAND="uptime"
# SSH connect
output=$(ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} ${COMMAND})
echo $output
```
Tham số -o để tự động thêm host vào file known_hosts trong trường hợp kết nối đầu tiên các bạn sẽ gặp phải message như sau
```
The authenticity of host ‘[vinasupport.com]’ can’t be established.
ECDSA key fingerprint is SHA256:Ge8ttoZq6AjZqQ4vWAk2gGOz9U1Vxx1123456677
Are you sure you want to continue connecting (yes/no)?
```
Kết nối SSH và chạy nhiều command

```
#!/usr/bin/env bash
# Define variables
HOST=vinasupport.com
USER=root
PORT=22
IFS='' read -r -d '' COMMAND <<'EOF'
cd /tmp
echo 'We are vinasupport team' > test.txt
cat test.txt
EOF
echo "$COMMAND"
# SSH connect
output=$(ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} "$COMMAND")
echo $output
```

Kết nối SSH với password
2 ví dụ ở trên là chúng ta thực hiện tạo SSH Keys để kết nối nên không cần nhập password, nhưng trường hợp các bạn muốn sử dụng password để xác thực ssh thì hãy cài 1 package có tên là sshpass

```
# On Ubuntu/Debian
sudo apt-get install sshpass
# On Redhat/CentOS
sudo yum install sshpass
```

Scripts
```
#!/usr/bin/env bash
# Define variables
HOST=vinasupport.com
USER=root
PASSWORD=123456
PORT=22
IFS='' read -r -d '' COMMAND <<'EOF'
cd /tmp
echo 'We are vinasupport team' > test.txt
cat test.txt
EOF
echo "$COMMAND"
# SSH connect
output=$( sshpass -p '${PASSWORD}' ssh -o StrictHostKeyChecking=no ${USER}@${HOST} -p ${PORT} "$COMMAND")
echo $output
```

Trong đó: 
sshpass với tham số -p: Sử dụng password ở dạng plan text
sshpass với tham số -f: Sử dụng password trong 1 file, chúng ta cần tạo 1 file lưu password
sshpass với tham số -3: Sử dụng password của 1 biến môi trường


