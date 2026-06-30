Trong quá trình quản trị hệ thống Linux (đặc biệt là Ubuntu), việc bạn nhìn thấy file: `50-cloud-init.yaml` bên cạnh file `01-netcfg.yaml` trong thư mục `/etc/netplan/` là rất phổ biến.

Tuy nhiên, dưới góc độ DevOps, chúng ta không nên chỉnh sửa trực tiếp hoặc dùng file 50-cloud-init.yaml để cấu hình IP tĩnh vì những lý do mang tính "sống còn" sau:

1. File này sẽ bị Ghi đè (Overwrite) và Mất cấu hình bất cứ lúc nào

cloud-init là một dịch vụ tự động hóa (automation tool) được các nhà cung cấp Cloud (AWS, iNET, Viettel, OpenStack...) tích hợp sẵn vào OS image.
Mỗi khi server của bạn khởi động lại (Reboot), hoặc khi nhà cung cấp cập nhật hạ tầng, dịch vụ cloud-init sẽ tự động chạy và ghi đè (regenerate) lại toàn bộ nội dung file 50-cloud-init.yaml dựa trên thông tin nó lấy từ metadata của hạ tầng.

⚠️ Hậu quả: Nếu bạn tự sửa IP tĩnh trong file này, sau khi reboot server, mọi cấu hình của bạn sẽ bị xóa sạch, file quay về trạng thái mặc định, dẫn đến mất mạng và mất kết nối SSH.

2. Nguyên tắc ưu tiên theo số thứ tự của Netplan

Netplan đọc các file cấu hình theo thứ tự bảng chữ cái (alphabetical order) dựa trên tiền tố số ở đầu tên file (01-, 50-, 99-).
- Các file có số nhỏ hơn (như 01-netcfg.yaml) sẽ được đọc trước.
- Các file có số lớn hơn (như 50-cloud-init.yaml) được đọc sau và có quyền ghi đè các thông số của file đọc trước nếu trùng tên card mạng.
- Thứ tự đọc: 01 -> 50 -> 99 (Từ nhỏ đến lớn)
- Thứ tự ưu tiên áp dụng: 99 > 50 > 01 (File đọc sau cùng sẽ đè lên file đọc trước).

Do đó, người ta thường tạo ra một file riêng có số thứ tự nhỏ hơn hoặc lớn hẳn để quản lý độc lập, tránh việc can thiệp chéo cấu hình của hệ thống tự động.

Kịch bản chuẩn DevOps để cấu hình mạng trên Ubuntu:

Nếu bạn muốn cấu hình IP tĩnh (Static IP) một cách an toàn và vĩnh viễn, bạn có 2 cách:

Cách 1: Tắt hoàn toàn tính năng cấu hình mạng của cloud-init (Khuyên dùng)

Nếu không muốn cloud-init tự động động vào card mạng nữa, bạn tạo một file sau:
```
echo "network: {config: disabled}" > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
```

Sau đó, bạn có thể toàn quyền xóa file 50-cloud-init.yaml đi và tự viết cấu hình mạng của mình vào một file mới (ví dụ: 01-netcfg.yaml).

Cách 2: Sử dụng file cấu hình tùy biến riêng

Bạn cứ để mặc định file 50-cloud-init.yaml ở đó, và tạo hẳn một file mới tên là 99-custom-config.yaml. Vì số 99 lớn hơn 50, nên các cấu hình IP của bạn tại file này sẽ đè lên cấu hình tự động của cloud-init một cách hợp lệ mà không sợ bị xóa mất khi reboot.
