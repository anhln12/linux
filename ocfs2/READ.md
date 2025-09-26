OCFS2 (Oracle CLuter File System v2) là một cluster file system cho phép nhiều máy (node) trong cùng một cụm cùng mount và r/w cùng 1 phân vùng theo thời gian thực.

KHác với NFS (client-server) hay rsync, OCFS2 cho phép các node truy cập trực tiếp vào một block device được shared (SAN, iSCI, DRBD)

Đặc điểm:


|Tính năng| Mô tả|

| Cluster aware| Nhiều node cùng mount cùng một volume r/w trực tiếp|

