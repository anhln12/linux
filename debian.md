install mysql client

apt-get install default-mysql-client

Setting the System Proxy on Debian 11/10: For APT Package Manager

sudo vim /etc/apt/apt.conf.d/80proxy
Acquire::http::proxy "http://[desired_IP]:8080/";
Acquire::https::proxy "https://[desired_IP]:8080/";
Acquire::ftp::proxy "ftp://[desired_IP]:8080/";
