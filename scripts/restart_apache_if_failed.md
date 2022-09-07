# Restart Apache if failed
This bash script check web site every 5 minutes, restart the web server if web site is not responding.

Step 1: Create a file
```
mkdir /usr/serverok
vi /usr/serverok/check_httpd.sh
```

Step 2: Add
```
#!/bin/bash
# Author: Le Anh
# Web: https://serverok.in
# Email: anhle0412@gmail.com

/usr/bin/wget --tries=1 --timeout=30 -O /dev/null https://YOUR_DOMAIN.EXTN/

if [ $? -ne 0 ]; then
    systemctl restart httpd
    datetime=`date "+%Y%m%d %H:%M:%S"`
    echo $datetime "failure">>/var/log/sok-web.log
fi
```

Step 3: Make it executable
```
chmod 755 /usr/serverok/check_httpd.sh
```

Step 4: Create a cronjob
```
*/5 * * * *  /usr/serverok/check_httpd.sh > /dev/null 2>&1
```
