CÀI ĐẶT APACHE KAFKA TRÊN CENTOS 7

Mục lục
Apache Kafka là gì?
Chuẩn bị môi trường
Cài đặt OpenJDK8
Tạo user kafka
Cài đặt và giải nén Kafka Binaries
Cấu hình Kafka Server
Tạo Systemd Unit file và khởi động Kafka Server
Kiểm tra cài đặt
Kết luận

**Apache Kafka là gì?**

Apache Kafka (Kafka) là một nền tảng phân phối dữ liệu phân tán (distributed messaging system), sử dụng mô hình publish – subscribe, bên publish dữ liệu được gọi là producer, bên subscribe nhận dữ liệu theo topic được gọi là consumer. 

Kafka có khả năng phân phối một lượng lớn dữ liệu theo thời gian thực, trong trường hợp bên nhận chưa nhận được dữ liệu, dữ liệu vẫn được lưu trữ, sao lưu trên một hàng đợi và cả trên ổ cứng server để bảo đảm tính toàn vẹn dữ liệu. 

Trong bài viết này mình sẽ hướng dẫn cho các bạn cách cài đặt Apache Kafka trên Centos 7.

Chuẩn bị môi trường:
* Centos 7
* User có quyền sudo
* JDK

Cài đặt OpenJDK8
```
yum install java-1.8.0-openjdk.x86_64
```

Tạo user kafka

Chúng ta sẽ tạo 1 user với tên gọi là “kafka” thuộc group “wheel” – người dùng thuộc group này được thực hiện toàn bộ các câu lệnh.

```
useradd kafka -m
usermod -aG wheel kafka
su -l kafka
```

Option “-m” sẽ tạo 1 thư mục chính cho user. Thư mục /home/kafka sẽ là nơi chúng ta thực hiện các bước tiếp theo.

Cài đặt và giải nén Kafka Binaries
```
curl "http://mirrors.viethosting.com/apache/kafka/2.3.0/kafka_2.12-2.3.0.tgz" -o ~/kafka.tgz
```

Tạo 1 thư mục kafka và di chuyển vào thư mục này. Đây sẽ là thư mục chứa cấu hình để cài đặt kafka
```
mkdir -p ~/kafka && cd ~/kafka
```

Thực hiện giải nén file Binaries đã download
```
tar -xvzf ~/kafka.tgz --strip 1
```

Cấu hình Kafka Server

Mặc định Kafka sẽ không cho phép chúng ta xóa các topic. Để chỉnh sửa chúng ta sẽ vào file cấu hình của kafka:

```
vi ./config/server.properties
```

Thêm dòng cấu hình cho phép xóa topic vào cuối file
```
delete.topic.enable = true
```

Tạo Systemd Unit file và khởi động Kafka Server

Chúng ta sẽ tạo Systemd unit file cho dịch vụ kafka để có thể dễ dàng quản lý các hành động như start, stop hoặc restart. 

Zookeeper là 1 dịch vụ mà kafka sử dụng để quản lý cấu hình và trạng thái của cụm cluster. Tạo systemd unit file cho zookeeper
```
vi /etc/systemd/system/zookeeper.service
```

Thêm các dòng sau vào file:
```
[Unit]

Requires=network.target remote-fs.target

After=network.target remote-fs.target

[Service]

Type=simple

User=kafka

ExecStart=/home/kafka/kafka/bin/zookeeper-server-start.sh /home/kafka/kafka/config/zookeeper.properties

ExecStop=/home/kafka/kafka/bin/zookeeper-server-stop.sh

Restart=on-abnormal

[Install]

WantedBy=multi-user.target
```

Tiếp theo, chúng ta sẽ tạo Systemd unit file cho kafka:
```
vi /etc/systemd/system/kafka.service
```

Thêm các dòng sau vào file:
```
[Unit]

Requires=zookeeper.service

After=zookeeper.service

[Service]

Type=simple

User=kafka

ExecStart=/bin/sh -c '/home/kafka/kafka/bin/kafka-server-start.sh /home/kafka/kafka/config/server.properties > /home/kafka/kafka/kafka.log 2>&1'

ExecStop=/home/kafka/kafka/bin/kafka-server-stop.sh

Restart=on-abnormal

[Install]

WantedBy=multi-user.target
```

Khởi động dịch vụ kafka
```
systemctl start kafka
```

Kiểm tra trạng thái của dịch vụ:
```
systemctl status kafka
```

Bây giờ dịch vụ kafka đã được khởi động và listen port 9092

# Kiểm tra cài đặt

Đầu tiên, kết nối đến zookeeper thông qua port 2181 và tạo 1 topic với tên gọi là “TEST” với số lượng partition và replica là 1.
```
./bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic TEST
```

Thực hiện publish message vào topic TEST bằng câu lệnh sau:
```
echo "Hello, TEST" | ./bin/kafka-console-producer.sh --broker-list localhost:9092 --topic TEST > /dev/null
```

Để kiểm tra xem consumer đã nhận được message chưa ta thực hiện câu lệnh sau:
```
./bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic TEST --from-beginning
```
