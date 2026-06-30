#/etc/netplan/01-netcfg.yaml
network:
  version: 2

  ethernets:
    eno2:
      dhcp4: false
      addresses:
        - 103.154.62.xxx/24
      routes:
        - to: default
          via: 103.154.62.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 1.1.1.1
    eno5:
      dhcp4: false
      addresses:
        - 10.10.114.20/24
    eno3:
      dhcp4: false
      addresses:
        - 10.144.xxx.xxx/29
      routes:
        - to: 10.0.0.0/8
          via: 10.144.xxx.xxx
