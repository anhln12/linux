# Tạo SSH Key và xác thực kết nối SSH bằng Public/Private key

Cách tạo ra cặp Public và Private key của SSH, cấu hình sử dụng Public SSH key ở server, và Private SSH Key ở Client để chúng xác thực khi kết nối

Cơ chế xác thực bằng SSH Key
Ngoài cơ chế xác thức bằng cách nhập mật khẩu như trên còn có cơ chế sử dụng SSH Key để xác thực. Để tạo nên xác thực này cần có hai file, một file lưu Private Key và môt lưu Public key

Public Key khóa chung, là một file text - nó lại lưu ở phía Server SSH, nó dùng để khi Client gửi Private Key (file lưu ở Client) lên để xác thực thì kiểm tra phù hợp giữa Private Key và Public Key này. Nếu phù hợp thì cho kết nối.

Private Key khóa riêng, là một file text bên trong nó chứa mã riêng để xác thực (xác thực là kiểm tra sự phù hợp của Private Key và Public Key). 
Máy khách kết nối với máy chủ phải chỉ ra file này khi kết nối SSH thay vì nhập mật khẩu. Hãy lưu file Private key cận thận, bất kỳ ai có file này có thể thực hiện kết nối đến máy chủ của bạn

Tạo SSH Key (Public/Private)
Có nhiều cách để có được SSH Key (cặp Private Key và Public Key). Miễn là sau khi có căp file này thì file Public Key lưu ở vị trí phù hợp tại Server (xem trên), còn Private key dùng ở máy khách để kết nối. Dưới đây là một cách có được cặp file này (dùng lệnh ssh-keygen của OpenSSH chạy ở Server hoặc Client đều được):

Mở terminate (trên Linux, macOS hoặc cmd trên Windows) rồi gõ dòng lệnh:
```
ssh-keygen -t rsa
```
Đầu tiên nó hỏi nhập thư mục sẽ lưu key sinh ra, hãy nhập thư mục - tên file muốn lưu hoặc nhấn Enter để sử dụng đường dẫn nó gợi ý (~/.ssh/id_rsa, ví dụ trên máy tôi /Users/xuanthulab/.ssh/id_rsa). Sau đó nó yêu cầu nhập passphase, nhấn Enter để rỗng. Cuối cùng nó sinh ra hai file key có tên id_rsa và id_rsa.pub ở thư mục đã nhập trên.
