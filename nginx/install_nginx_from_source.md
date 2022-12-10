# Cài đặt các thư viện cần thiết
```
yum -y update
yum install epel-release
yum groupinstall -y 'Development Tools'
yum install -y perl perl-devel perl-ExtUtils-Embed libxslt libxslt-devel libxml2 libxml2-devel gd gd-devel GeoIP GeoIP-devel
```

# Download các gói cài đặt
```
wget https://nginx.org/download/nginx-1.21.6.tar.gz
wget https://sourceforge.net/projects/pcre/files/pcre/8.45/pcre-8.45.tar.gz
wget https://www.zlib.net/zlib-1.2.12.tar.gz
wget https://www.openssl.org/source/openssl-1.1.1o.tar.gz
```

# Giải nén các source chương trình
```
tar xf nginx-1.21.6.tar.gz
tar xf openssl-1.1.1o.tar.gz
tar xf pcre-8.45.tar.gz
tar xf zlib-1.2.12.tar.gz
```

# Cài đặt
```
cd nginx-1.21.6
./configure --prefix=/etc/nginx \
--sbin-path=/usr/sbin/nginx \
--modules-path=/usr/lib64/nginx/modules \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--user=nginx \
--group=nginx \
--build=CentOS \
--builddir=nginx-1.21.6 \
--with-select_module \
--with-poll_module \
--with-threads \
--with-file-aio \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_xslt_module=dynamic \
--with-http_image_filter_module=dynamic \
--with-http_geoip_module=dynamic \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_auth_request_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_degradation_module \
--with-http_slice_module \
--with-http_stub_status_module \
--http-log-path=/var/log/nginx/access.log \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
--with-mail=dynamic \
--with-mail_ssl_module \
--with-stream=dynamic \
--with-stream_ssl_module \
--with-stream_realip_module \
--with-stream_geoip_module=dynamic \
--with-stream_ssl_preread_module \
--with-compat \
--with-pcre=../pcre-8.45 \
--with-pcre-jit \
--with-zlib=../zlib-1.2.12 \
--with-openssl=../openssl-1.1.1o \
--with-openssl-opt=no-nextprotoneg \
--with-debug
```

# Cài xong
```
Configuration summary
+ using threads
+ using PCRE library: ../pcre-8.45
+ using OpenSSL library: ../openssl-1.1.1o
+ using zlib library: ../zlib-1.2.12

nginx path prefix: "/etc/nginx"
nginx binary file: "/usr/sbin/nginx"
nginx modules path: "/usr/lib64/nginx/modules"
nginx configuration prefix: "/etc/nginx"
nginx configuration file: "/etc/nginx/nginx.conf"
nginx pid file: "/var/run/nginx.pid"
nginx error log file: "/var/log/nginx/error.log"
nginx http access log file: "/var/log/nginx/access.log"
nginx http client request body temporary files: "/var/cache/nginx/client_temp"
nginx http proxy temporary files: "/var/cache/nginx/proxy_temp"
nginx http fastcgi temporary files: "/var/cache/nginx/fastcgi_temp"
nginx http uwsgi temporary files: "/var/cache/nginx/uwsgi_temp"
nginx http scgi temporary files: "/var/cache/nginx/scgi_temp"
```

# Biên dịch và cài đặt vào trong máy tính
```
make
make install
```

# Thiết lập file cấu hình cho Nginx
```
[root@thanhdd ~]# cd /usr/lib64/nginx/modules
# Tạo file shortcut /etc/nginx/modules
ln -s /usr/lib64/nginx/modules /etc/nginx/modules
# vi thử vào file config
vi /etc/nginx/nginx.conf
# tạo thêm user, user này không có khả năng loggin
adduser --system --no-create-home --user-group -s /sbin/nologin nginx
# tạo file chứa cache
mkdir -p /var/cache/nginx
# test web server nginx hoạt động được chưa
nginx -t
```

# Thiết lập dịch vụ nginx cho máy Centos 7
```
vi /usr/lib/systemd/system/nginx.service

[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

# Thử khởi động dịch vụ Nginx
```
systemctl start nginx
systemctl enable nginx
systemctl status nginx
netstat -ltunp
```
