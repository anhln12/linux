Với công cụ Ventoy, bạn có thể nhanh chóng/dễ dàng tạo ra một chiếc USB MultiBoot

Ventoy là gì?

Ventoy là công cụ cho phép bạn tạo USB Boot, USB MultiBoot. Nó là một công cụ nguồn mở và cho phép sử dụng miễn phí. Bạn chỉ cần cài đặt sau đó sao chép file ISO vào USB để khởi động từ chúng. Có thể nói Ventoy là công cụ tạo USB MultiBoot đơn giản nhất hiện tại.

Những tính năng nổi bật của Ventoy:
- Hỗ trợ cả BIOS Legacy x86 và UEFI (IA32, x86_64, ARM64, MIPS64EL)
- Hỗ trợ Secure Boot
- Hỗ trợ tự động cài đặt Windows và Linux
- Hỗ trợ các tệp ISO lớn hơn 4GB
- Hỗ trợ cả Linux vDisk (vhd/vdi/raw...)
- Có plugin

Những thứ cần chuẩn bị:
- Một máy tính hoặc laptop chạy Windows hoặc Linu
- USB dung lượng lớn (trên 16GB là tốt nhất)
- File ISO của các hệ điều hành bạn cần cài đặt

Tải Ventoy: https://www.ventoy.net/en/download.html

Cách cài đặt Ventoy:
- Để cài đặt Ventoy vào USB trên Windows bạn mở file vừa giải nén và chạy tệp Ventoy2Disk.exe
<img width="224" alt="image" src="https://github.com/user-attachments/assets/ea6c7167-52a1-42aa-8557-f11611337760">

- Tiếp theo, bạn chọn USB mà bạn muốn cài Ventoy rồi nhấn Install
- Nếu USB đã cài Ventoy và bạn muốn cập nhật phiên bản mới thì bạn nhấn Update
- Nếu muốn tăng cường bảo mật bạn có thể nhấn vào Options rồi chọn Secure Boot Support
- Sau đó bạn chờ quá trình cài đặt hoàn tất (phiên bản Ventoy sẽ hiển thị ở phần Ventoy In Device)
<img width="223" alt="image" src="https://github.com/user-attachments/assets/792ce3de-2405-4492-8240-f965fe112c09">

Copy tệp ISO vào USB
- Sau khi cài đặt xong, USB sẽ được chia thành 2 phân vùng. Phân vùng đầu tiên sẽ được format thành tệp hệ thống exFAT. Bạn chỉ cần copy tệp ISO vào phân vùng này. Ventoy cho phép bạn copy không giới hạn số lượng tệp ISO, miễn là USB của bạn đủ dung lượng.
- Bạn cũng có thể copy tệp iso/wim/img/vhd(x) vào bất kỳ chỗ nào trên USB. Ventoy sẽ tìm kiếm tất cả các thư mục và thư mục con để xác định tệp hệ điều hành và hiển thị chúng trong menu boot theo thứ tự bảng chữ cái.
- Bạn chỉ cần khởi động máy tính cần cài Win, Linux từ USB đó. Màn hình Ventoy sẽ khởi động để bạn chọn file ISO mà bạn muốn cài.
<img width="332" alt="image" src="https://github.com/user-attachments/assets/074512eb-2df5-4173-a5bd-95250c026f19">
