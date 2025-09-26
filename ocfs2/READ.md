OCFS2 (Oracle CLuter File System v2) là một cluster file system cho phép nhiều máy (node) trong cùng một cụm cùng mount và r/w cùng 1 phân vùng theo thời gian thực.

KHác với NFS (client-server) hay rsync, OCFS2 cho phép các node truy cập trực tiếp vào một block device được shared (SAN, iSCI, DRBD)

Đặc điểm:

| Tính năng           | Mô tả                                                |
|----------------------|------------------------------------------------------|
| Cluster aware        | Nhiều node cùng mount cùng một volume và đọc/ghi trực tiếp |
| Direct block access  | Truy cập trực tiếp block device chung (SAN, iSCSI, DRBD)   |
| Distributed Locking  | Sử dụng cơ chế khóa phân tán để đảm bảo tính nhất quán    |
| Journaling           | Ghi log giống ext4/xfs, giúp phục hồi khi sự cố           |
| Metadata Shared      | Toàn bộ metadata (inode, block bitmap ...) được chia sẻ giữa các node|
|Performance           | R/w trực tiếp qua block device => nhanh hơn NFS trong LAN (không cần server trung gian)|
|Quản lý dung lượng    | Hỗ trợ file lớn (lên đến TB(, quota, reflink|

Kiến trúc OCFS2:
- Cluster stack: Hearbeat, node manager, dlm
- Shared Storage: SAN, iSCSI, Fibre Channel, RDBD

Cài đặt OCFS2

1. Cài gói
```
apt install ocfs2-tools
```

2. Tạo Cluster (Tạo trên 1 node, rồi copy config qua các node khác)
```
o2cb add-cluster mycluster
o2cb add-node mycluster node1 --ip 10.0.0.1
o2cb add-node mycluster node2 --ip 10.0.0.2
o2cb add-node mycluster node3 --ip 10.0.0.2
o2cb add-node mycluster node4 --ip 10.0.0.2
o2cb configure
```

3. Tạo filesystem trên shared device (chạy 1 lần)
```
mkfs.ocfs2 -L mydata -N 4 /dev/sdX
```

note: -N 2 = số node trong cluster

4. Chỉnh config /etc/default/o2cb
```
O2CB_ENABLED=true (default flase => true)
O2CB_BOOTCLUSTER=ocfs2
O2CB_HEARTBEAT_THRESHOLD=7
O2CB_IDLE_TIMEOUT_MS=5000
O2CB_KEEPALIVE_DELAY_MS=1000
O2CB_RECONNECT_DELAY_MS=2000
```

5. Khởi động dịch vụ trên các node
```
systemctl enable o2cb
systemctl start o2cb
systemctl enable ocfs2
systemctl start ocfs2
```

6. Kiểm tra port đã chạy chưa
```
netstat -npl | grep 7777
```

5. Mount trên các node
```
mount -t ocfs2 -o _netdev /dev/sdX /mnt/ocfs2
```

Note:
- Tất cả các node phải nhìn thấy cùng một block device (SAN/iSCSI)
- Cluster name trong /etc/ocfs2/cluster.conf phải giống nhau trên tất cả các node
- Lỗi mount.ocfs2: Cluster name is invalid while trying to join the group do mình chưa chuyển config O2CB_ENABLED=true trong file config /etc/default/o2cb
- file config
```
/etc/ocfs2/cluster.conf

cluster:
        name = ocfs2
        node_count = 4

node:
        cluster = ocfs2
        number = 1
        ip_port = 7777
        ip_address = 10.0.133.233
        name = STREAMING-01

node:
        cluster = ocfs2
        number = 2
        ip_port = 7777
        ip_address = 10.0.133.235
        name = STREAMING-02

node:
        cluster = ocfs2
        number = 3
        ip_port = 7777
        ip_address = 10.0.133.237
        name = STREAMING-03

node:
        cluster = ocfs2
        number = 4
        ip_port = 7777
        ip_address = 10.0.133.239
        name = STREAMING-04
```

