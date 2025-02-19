Nếu bạn muốn mount ổ đĩa mới trong linux để đảm bảo rằng sau này có thể thêm ổ mới mở rộng dung lượng thì bản phải sử dụng LVM (Logical Volume Manager).

Bước 1: Kiểm tra ổ đĩa mới
```
lsblk
fdisk -l
```

Bước 2: Tạo Physical Volume (PV) => chuyển ổ thành Physical Volume để dùng với LVM
```
pvcreate /dev/sdb
pvdisplay => Kiểm tra lại
```

Bước 3: Tạo Volume Group (VG) => Nếu bạn chưa có Volume Group, hãy tạo một cái mới
```
vgcreate vgdata /dev/sdb
pvdisplay => Kiểm tra lại
```

Bước 4: Tạo Logical Volume (LV) => Tạo Logical Volume (vd: lvdata, 100% dung lượng VG)
```
lvcreate -l 100%FREE -n lvdata vgdata
lvdisplay
```

Bước 5: Định dạng và mount LV
```
mkfs.ext4 /dev/vgdata/lvdata
mkdir /mnt/data
mount /dev/vgdata/lvdata /mnt/data
```

Bước 6: Mount tự động khi khởi động
```
echo "/dev/vgdata/lvdata /mnt/data ext4 defaults 0 2" | sudo tee -a /etc/fstab
```

Bước 7: Sau này muốn thêm ổ mới

7.1 Thêm ổ mới vd: /dev/sdc

7.2 Tạo PV
```
pvcreate /dev/sdc
```

7.3 Mở rộng VG
```
vgextend vgdata /dev/sdc
```
7.4 Mở rộng LV
```
lvextend -l +100%FREE /dev/vgdata/lvdata
```

7.5 Risize filesystem
```
sudo resize2fs /dev/vgdata/lvdata  # Nếu dùng ext4
sudo xfs_growfs /mnt/data          # Nếu dùng XFS
```

Ex: Logs
```
root@:~# fdisk -l
Disk /dev/sda: 200 GiB, 214748364800 bytes, 419430400 sectors
Disk model: Virtual disk    
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 3751534D-9079-4E81-B2C9-17CC6CCB7049

Device     Start       End   Sectors  Size Type
/dev/sda1   2048      4095      2048    1M BIOS boot
/dev/sda2   4096 419428351 419424256  200G Linux filesystem


Disk /dev/sdb: 200 GiB, 214748364800 bytes, 419430400 sectors
Disk model: Virtual disk    
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
root@cambridge:~# pvcreate /dev/sdb
  Physical volume "/dev/sdb" successfully created.
root@:~# pvdisplay
  "/dev/sdb" is a new physical volume of "200.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdb
  VG Name               
  PV Size               200.00 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               RXzehi-UjXn-OVr0-mY3g-Fdxf-ZGzC-H7cgdX
   
root@:~# vgcreate vgdata /dev/sdb
  Volume group "vgdata" successfully created
root@:~# pvdisplay
  --- Physical volume ---
  PV Name               /dev/sdb
  VG Name               vgdata
  PV Size               200.00 GiB / not usable 4.00 MiB
  Allocatable           yes 
  PE Size               4.00 MiB
  Total PE              51199
  Free PE               51199
  Allocated PE          0
  PV UUID               RXzehi-UjXn-OVr0-mY3g-Fdxf-ZGzC-H7cgdX
   
root@:~# lvcreate -l 100%FREE -n lvdata vgdata
  Logical volume "lvdata" created.
root@:~# pvdisplay
  --- Physical volume ---
  PV Name               /dev/sdb
  VG Name               vgdata
  PV Size               200.00 GiB / not usable 4.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              51199
  Free PE               0
  Allocated PE          51199
  PV UUID               RXzehi-UjXn-OVr0-mY3g-Fdxf-ZGzC-H7cgdX
   
root@:~# mkfs.ext4 /dev/vgdata/lvdata
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 52427776 4k blocks and 13107200 inodes
Filesystem UUID: dcc2fadb-7ded-49fc-96b5-319e3fbecad9
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
        4096000, 7962624, 11239424, 20480000, 23887872

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (262144 blocks): 

done
Writing superblocks and filesystem accounting information:          
done
```



