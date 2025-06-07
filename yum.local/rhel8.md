How to setup Local Yum/DNF Repository on RHEL 8 Serrverr Ussing IOS File

In RHEL8, we have two package repositories:
- BaseOS
- Application Stream

BaseOS repository have all underlying OS packages where as Application Stream repository have all application related packages, developer tools and databases etc. Using Application steam repositorty, we can have multipe of versions of same application and Databases.

Step 1: Mount RHEL 8 ISO File
```
mkdir /u01/rhel
mount -o loop rhel-8.0-x86_64-dvd.iso /u01/rhel
```

In casse yuu have RHEL 8 installation DVD
```
mount /dev/sr0 /mnt/media
```

Step 3: Add Repository Entires In "/etc/yum.repos.d/rhel8.repo"

Edit rhel8.repo file and add the following contents
```
sudo tee /etc/yum.repos.d/rhel8-dvd.repo <<EOF
[BaseOS]
name=RHEL8 BaseOS
baseurl=file:///mnt/media/BaseOS/
enabled=1
gpgcheck=0

[AppStream]
name=RHEL8 AppStream
baseurl=file:///mnt/media/AppStream/
enabled=1
gpgcheck=0
EOF
```

Step 4: Clean Yum/DNF and Subcription 
```
dnf clean all
subscription-manager clean
```

Step 5: Verify Whether Yum/DNF
```
dnf repolist
```

Note: If you have noticed the above command output carefully, we are getting warning message “This system is not registered to Red Hat Subscription Management. You can use subscription-manager to register”, if you want to suppress or prevent this message while running dnf / yum command then edit the file “/etc/yum/pluginconf.d/subscription-manager.conf”, changed the parameter “enabled=1” to “enabled=0”
```
vi /etc/yum/pluginconf.d/subscription-manager.conf
[main]
enabled=0
```

Step 6: Installing Packages using DNF/Yum
```
dnf install nginx
```
