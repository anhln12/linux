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

Kết quả lệnh trên bạn đã có:
Private Key chứa trong file ~/.ssh/id_rsa, hãy lưu lại cẩn thận, nó được dùng để SSH client (máy local) kết nối đến Server. Mở file này ra, đoạn mã Private Key có dạng
Public Key chứa trong file ~/.ssh/id_rsa.pub, hãy copy nội dung bên trong file - giữ cận thận, Nó được lưu (dùng) ở máy Server để xác thực khi có Private key gửi đến. Nếu mở file này ra, thì nội dung mã Public key nhìn thấy có dạng:

# Xác thực bằng SSH Key
Khi SSH Server bật chế độ cho phép xác sự bằng SSH Key, thì tại Server cấu hình để nó nhận biết có Public Key lưu ở file nào đó trên Server. Sau đó, ở máy Client (local) khi kết nối sẽ gửi Private Key lên, nếu nó kiểm tra thấy phù hợp giữa Public Key và Private Key thì cho kết nối.

Cấu hình Public key cho SSH Server
Mở file config của SSH Service ra (/etc/ssh/sshd_config trên Windows C:\ProgramData\sshd_config - xem phần Câu hình dịch vụ SSH Server ), hãy đảm bảo nó có dòng cấu hình:
```
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys
```
Trong đó .ssh/authorized_keys cho biết, tìm Public key tại file .ssh/authorized_keys của User. Có nghĩa là Public key sẽ phải có cho từng User kết nối, và nó lưu dưới thư mục của User.

Ví dụ, nếu user đăng nhập có tên là abc thì Public key phải lưu ở /home/abc/.ssh/authorized_keys (Linux) hay tại C:\Users\abc\.ssh\authorized_keys đối với Windows. Biết được đường dẫn như vậy, bạn cần copy file id_rsa.pub (chứa Public key) sinh ra ở trên vào đúng đường dẫn này (đổi tên id_rsa.pub thành authorized_keys). Hoặc tạo file authorized_keys rồi paste nội dung Public key vào.

Ví dụ, Linux Server có IP 192.168.1.52, user để là ht_anhln, thì file lưu Public Key phải để tại là ở /home/ht_anhln/.ssh/authorized_keys

Lưu ý - Lỗi hay gặp không kết nối được SSH KEY: thường là lưu file public key ở Server ở các thư mục không được chmod phù hợp. Nếu user có tên là abc, thì chmod phù hợp là:
```
/home/abc                               700
/home/abc/.ssh                          700
/home/abc/.ssh/authorized_keys          600
```
Cấu hình Private key cho SSH Client
Sau khi có SSH Server cho phép xác thực bằng SSH Key, thì ở Client phải sử dụng Private key, có được khi sinh ra cùng Public key ở trên.

Như phần File cấu hình config cho SSH Client , mở (tạo mới nếu chưa có) file config ra và thiết lập có xác thực SSH Key đến host tương ứng

Ví dụ, kết nối đến 192.168.1.52 thì dùng Private key lưu tại /Users/ht_anhln/.ssh/id_rsa, thì file config đó như sau:
```
Host 192.168.1.52
    PreferredAuthentications publickey
    IdentityFile "/Users/ht_anhln/.ssh/id_rsa"
```
Do public key ở 192.168.1.52 phù hợp với private key ở client (/Users/ht_anhln/.ssh/id_rsa), nên khi kết nối nó sẽ xác thực ngay bằng key mà không cần nhập password nữa

ssh ht_anhln@192.168.1.52
