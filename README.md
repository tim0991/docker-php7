# About this repository
Just for an automated build


# Docker hub
```
docker pull tim0991/php7
```


# 国内
```
docker pull daocloud.io/gtg0991/php7
```


# Included

*   php
*   supervisor


# Quickstart
更换上自己的路径
```
docker run \
-p yourport:9000 \
-v php.ini:/usr/local/php/etc/php.ini \
-v www.conf:/usr/local/php/etc/php-fpm.d/www.conf \
-v supervisor.conf:/etc/supervisor/conf.d/supervisor.conf \
-v start.sh:/usr/bin/start.sh \
-v /var/www:/var/www \
tim0991/php7
```

当你运行容器的时候， `/usr/bin/start.sh`将被执行，所以你可以将一些初始化命令写入这个脚本中
##example with start.sh
```
#!/bin/bash
/usr/local/php/sbin/php-fpm &
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf &
tail -f /usr/local/php/var/log/php-fpm.log
```
