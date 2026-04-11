#!/bin/bash

# Thư mục lưu trữ backup
BACKUP_DIR="/backup/os_info/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

echo "Starting OS configuration backup to $BACKUP_DIR..."

# 1. Network: IP, Route, DNS, Hosts
ip addr show > "$BACKUP_DIR/ip_addr.txt"
ip route show > "$BACKUP_DIR/routes.txt"
cat /etc/resolv.conf > "$BACKUP_DIR/dns_resolv.txt"
cat /etc/hosts > "$BACKUP_DIR/hosts.txt"
netstat -nplt > "$BACKUP_DIR/listening_ports.txt"

# 2. Firewall & Security (UFW)
ufw status numbered > "$BACKUP_DIR/ufw_status.txt"
iptables -L -n -v > "$BACKUP_DIR/iptables_rules.txt"

# 3. Storage & Mounts
df -h > "$BACKUP_DIR/disk_usage.txt"
lsblk > "$BACKUP_DIR/block_devices.txt"
cat /etc/fstab > "$BACKUP_DIR/fstab.txt"

# 4. OS Version & Kernel
hostnamectl > "$BACKUP_DIR/hostname_os_info.txt"
uname -a > "$BACKUP_DIR/kernel_info.txt"

# 5. Service & Crontab
systemctl list-unit-files --type=service --state=enabled > "$BACKUP_DIR/enabled_services.txt"
crontab -l > "$BACKUP_DIR/root_crontab.txt" 2>/dev/null

# 6. Package List (Để cài lại máy khi cần)
dpkg --get-selections > "$BACKUP_DIR/installed_packages.txt"

# Nén lại cho gọn
cd /backup/os_info
tar -czf "os_backup_$(date +%Y%m%d).tar.gz" "$(basename "$BACKUP_DIR")"
rm -rf "$BACKUP_DIR"

echo "Backup completed: /backup/os_info/os_backup_$(date +%Y%m%d).tar.gz"
