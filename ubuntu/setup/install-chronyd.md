NTP Chrony trên Ubuntu

1. Install
```
sudo apt update
sudo apt install chrony -y
```

2. Config
```
vi /etc/chrony/chrony.conf

server 0.pool.ntp.org iburst
server 1.pool.ntp.org iburst
server 2.pool.ntp.org iburst
server 3.pool.ntp.org iburst
```

3. Restart
```
systemctl restart chrony
```

4. Open Firewall
```
ufw allow 123/udp
```

5. Verify
```
timedatectl
chronyc sources -v
chronyc tracking
```
