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

Apache Kafka là gì?

Apache Kafka (Kafka) là một nền tảng phân phối dữ liệu phân tán (distributed messaging system), sử dụng mô hình publish – subscribe, bên publish dữ liệu được gọi là producer, bên subscribe nhận dữ liệu theo topic được gọi là consumer. 

Kafka có khả năng phân phối một lượng lớn dữ liệu theo thời gian thực, trong trường hợp bên nhận chưa nhận được dữ liệu, dữ liệu vẫn được lưu trữ, sao lưu trên một hàng đợi và cả trên ổ cứng server để bảo đảm tính toàn vẹn dữ liệu. 

Trong bài viết này mình sẽ hướng dẫn cho các bạn cách cài đặt Apache Kafka trên Centos 7.

Chuẩn bị môi trường:
* Centos 7
* User có quyền sudo
* JDK
