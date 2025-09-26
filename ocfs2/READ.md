OCFS2 (Oracle CLuter File System v2) là một cluster file system cho phép nhiều máy (node) trong cùng một cụm cùng mount và r/w cùng 1 phân vùng theo thời gian thực.

KHác với NFS (client-server) hay rsync, OCFS2 cho phép các node truy cập trực tiếp vào một block device được shared (SAN, iSCI, DRBD)

Đặc điểm:

| Tính năng           | Mô tả                                                |
|----------------------|------------------------------------------------------|
| Cluster aware        | Nhiều node cùng mount cùng một volume và đọc/ghi trực tiếp |
| Direct block access  | Truy cập trực tiếp block device chung (SAN, iSCSI, DRBD)   |
| Distributed Locking  | Sử dụng cơ chế khóa phân tán để đảm bảo tính nhất quán    |
| Journaling           | Ghi log giống ext4/xfs, giúp phục hồi khi sự cố           |

