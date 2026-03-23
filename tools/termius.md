Dù bạn đã chạy Termius bằng quyền Admin để chiếm Port 443 thành công, bạn vẫn không login được vì cơ chế "SSL Certificate Subject Alternative Name (SAN)" của ESXi.

1. Tại sao "Quyền Admin" vẫn thất bại?
Đây là luồng đi của lỗi:

vSphere Client kết nối tới localhost:443 (máy của bạn).

ESXi nhận được yêu cầu và gửi trả lại một Chứng chỉ SSL (Certificate).

Vấn đề: Trong chứng chỉ này, ESXi khai báo tên của nó là 192.168.192.101 (hoặc hostname thật).

Hậu quả: vSphere Client của bạn nhìn thấy chứng chỉ nhưng bảo: "Ủa, tôi đang gọi localhost cơ mà, sao chứng chỉ lại ghi là 192.168.192.101?". Để bảo mật, nó sẽ ngắt kết nối ngay lập tức vì nghi ngờ bị tấn công giả mạo (Man-in-the-middle).

MobaXterm làm được vì nó tích hợp sẵn một bộ driver mạng riêng có khả năng "giả lập" và xử lý các lỗi SSL Cert một cách thông minh, còn Termius thì tuân thủ chuẩn SSH thuần túy nên bị chặn đứng.

2. Giải pháp: Bạn phải "Lừa" vSphere Client bằng file Hosts
Để giải quyết vấn đề này, bạn phải bắt vSphere Client nghĩ rằng nó đang gọi đến IP thật của ESXi. Hãy làm theo 3 bước sau:

Bước 1: Sửa lại file hosts trên Windows

Nhấn Windows, gõ "Notepad", chuột phải và chọn "Run as administrator".

Nhấn Ctrl+O, dán đường dẫn này: C:\Windows\System32\drivers\etc\hosts và mở file.

Thêm dòng này vào cuối file:
127.0.0.1  esxi-ntl.local (Hoặc bất kỳ cái tên nào bạn muốn, ví dụ my-esxi).

Lưu file lại.

Bước 2: Sửa lại Termius (Dùng quyền Admin)

Mở Termius (quyền Admin).

Sửa lại Port Forwarding:

Local port number: 443.

Bind address: Để trống (hoặc điền 127.0.0.1).

Destination address: 192.168.192.101.

Destination port: 443.

Nhấn Connect.

Bước 3: Đăng nhập vSphere Client
Bây giờ, thay vì gõ IP, hãy gõ cái tên bạn vừa đặt trong file hosts:

IP address / Name: esxi-ntl.local.

User name / Password: (Nhập như bình thường).

3. Tại sao cách này lại thành công?
vSphere Client kết nối tới esxi-ntl.local.

Windows xem file hosts, thấy esxi-ntl.local trỏ về 127.0.0.1 (localhost).

Termius (quyền Admin) đang lắng nghe ở localhost:443, nhận request và đẩy qua Tunnel.

vSphere Client nhận được chứng chỉ từ ESXi. Lúc này, nó không còn so sánh với localhost nữa, mà so sánh với cái tên "lạ" esxi-ntl.local, và thường thì vSphere Client sẽ cho phép bạn bấm "Ignore" để bỏ qua lỗi Cert không khớp tên để login.

Cảnh báo: Dù login được bằng cách này, bạn sẽ vẫn gặp lỗi không mở được màn hình Console máy ảo (lỗi Port 902).

Bạn hãy thử làm theo 3 bước trên và cho tôi biết nếu vSphere Client hiện ra cửa sổ báo lỗi Chứng chỉ để bạn bấm "Ignore" (Bỏ qua) không nhé! Nếu có, bạn đã thành công ở bước đăng nhập.
