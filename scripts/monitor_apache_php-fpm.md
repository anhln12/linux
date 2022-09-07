# PHP Script to monitor Apache/php-fpm

health-check.php
```
<?php $id = (int) $_GET["sok"]; echo $id;
```

monitor-server.php
```
mkdir  /usr/serverok/
vi  /usr/serverok/monitor-server.php
```

Add following content
```
<?php

$myNumber = rand(1,100);

$monitorUrl = "https://YOUR_DOMAIN_HERE/health-check.php?sok=" . $myNumber;
$ch = curl_init($monitorUrl);
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch,CURLOPT_TIMEOUT,4);
$output = curl_exec($ch);      
curl_close($ch);

if ($output != $myNumber) {
    $cmd = "systemctl restart apache2";
    exec($cmd);
    $cmd = "systemctl restart php7.2-fpm";
    exec($cmd);
    $timeStamp = date("Y-m-d H:i:s");
    error_log("$timeStamp restarted", 3, "/var/log/sok-monitor.log");
}
```

Set a crontab
```
*/5 * * * * /usr/bin/php /usr/serverok/monitor-server.php
```
