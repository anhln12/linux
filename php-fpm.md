How to install php from source code with CentOS 7.8

1. Go to https://www.php.net/downloads and download php source code in *.tar.gz archive

2. Unarchive the package:

```
tar -xf php-7.2.31.tar.gz
```

3. Go to directory with unarchived php files and run “configure” script:

```
./configure --prefix=/usr/local/php7.2.31 --with-mysqli --with-pdo-mysql --with-iconv-dir --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir --enable-simplexml --enable-xml --disable-rpath --enable-bcmath --enable-soap --enable-zip --with-curl --enable-fpm --with-fpm-user=nobody --with-fpm-group=nobody --enable-mbstring --enable-sockets --with-gd --with-openssl --with-mhash --enable-opcache --disable-fileinfo
```

If some dependencies are not installed in your system the configure script will fail and tell you which dependencies are need to be installed first.

5.       If configure script is finished successfully run following command to compile php:

make

6.       Run command to install php:

make install

php will be install to /usr/local/php7.2.31 directory, which was specified as argument in configure script earlier on Step 4.

7.       Go to /usr/local/php7.2.31/etc/ and run:

cp php-fpm.conf.default php-fpm.conf

8.       Go to /usr/local/php7.2.31/etc/php-fpm.d and run:

cp www.conf.default www.conf

9.       Run following command to start php-frpm:

/usr/local/php7.2.31/sbin/php-fpm

10.   Run following command to make sure php-fpm process has started successfully:

ps -ef | grep php-fpm

If you are able to see php-fpm process in the output - you have successfully installed php on Huawei Taishan server.
