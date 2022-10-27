Firewall-cmd is the command line client of the firewalld deamon. It provides interface to manage runtime and permanent configuration.

1. Active zones and services:
```
#firewall-cmd --get-active-zones
#firewall-cmd --get-services
```

2. Add and remove ports and services in firewalld

Adding ports and services:
```
#firewall-cmd --permanent --zone=public --add-port=80/tcp
#firewall-cmd --permanent --zone=public --add-service=ftp
```

Removing ports and services:
```
#firewall-cmd --zone=public --remove-port=80/tcp
#firewall-cmd --zone=public --remove-service=ftp
```

List active ports and services
```
#firewall-cmd --zone=public --list-ports
#firewall-cmd --zone=public --list-services
```

3. Block Incoming and Outgoing Packets (Panic Mode)

To turn on and check the panic mode with --query-panic:
```
#firewall-cmd --panic-on
#ping hostnextra.com
#firewall-cmd --query-panic
```

To turn off and check the panic mode with --query-panic:
```
#firewall-cmd -query-panic
#fiewall-cmd --panic-off
#ping oyoservers.com
```

4. Adding and Removing Chain using Direct Interface
```
# firewall-cmd –direct –add-rule ipv4 filter IN_public_allow 0 -m tcp -p tcp –dport 25 -j ACCEPT
# firewall-cmd –direct –remove-rule ipv4 filter IN_public_allow 0 -m tcp -p tcp –dport 25 -j ACCEPT
```

5. Adding & Bloking IP Addresses
```
# firewall-cmd –zone=public –add-rich-rule=’rule family=”ipv4″ source address=”172.16.0.11″ ACCEPT
# firewall-cmd –zone=public –remove-rich-rule=’rule family=”ipv4″ source address=”172.16.0.11″ ACCEPT
```

