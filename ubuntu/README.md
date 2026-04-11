backup_os_info.sh

Giải thích các thành phần quan trọng
dpkg --get-selections: Đây là "bản đồ" các phần mềm đã cài. Nếu máy hỏng, bạn chỉ cần file này để cài lại toàn bộ gói cũ.

ufw status numbered: Lưu lại các rule firewall theo số thứ tự để dễ đối chiếu.

lsblk & fstab: Cực kỳ quan trọng để biết cấu trúc ổ đĩa và các phân vùng tự động mount khi khởi động lại.

systemctl list-unit-files: Giúp bạn biết những dịch vụ nào (như Redis, Zabbix Agent, Oracle) đang được set tự động chạy cùng OS.
