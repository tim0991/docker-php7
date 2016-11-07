FROM debian:jessie

RUN apt-get update && apt-get install -y \
    autoconf \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    pkg-config \
    re2c \
    xz-utils \
    --no-install-recommends -qqy && rm -r /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    libedit2 \
    libsqlite3-0 \
    libxml2 \
    libcurl4-openssl-dev \
    libedit-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libpng12-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libc-client2007e-dev \
    libkrb5-dev \
    xz-utils \
    unzip \
    vim \
    netcat \
    redis-tools \
    mysql-client \
    --no-install-recommends -qqy  && rm -r /var/lib/apt/lists/*

ENV PHP_VERSION php-7.0.7
ENV PHP_DIR /usr/local/php

#install php7
RUN curl http://uk1.php.net/distributions/${PHP_VERSION}.tar.xz -o /tmp/${PHP_VERSION}.tar.xz  \
&& tar -xvJf /tmp/${PHP_VERSION}.tar.xz -C /tmp/ \
&& cd /tmp/${PHP_VERSION} \
&& ./configure -prefix=$PHP_DIR \
    --with-config-file-path=$PHP_DIR/etc \
    --with-config-file-scan-dir=$PHP_DIR/etc/conf.d \
    -with-iconv --enable-mbstring \
    -with-mcrypt -with-zlib \
    -with-gd -enable-gd-native-ttf --with-jpeg-dir --with-png-dir\
    -enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data \
    -with-openssl --with-zlib -enable-pcntl -enable-sockets -with-xmlrpc  -with-curl -enable-opcache \
    -enable-mysqlnd -with-pdo-mysql  -with-mysqli \
    --with-imap --with-imap-ssl --with-kerberos\
&& make -j "$(nproc)" \
&& make install \
&& make clean \
&& mv $PHP_DIR/etc/php-fpm.conf.default $PHP_DIR/etc/php-fpm.conf \
&& ln -s $PHP_DIR/sbin/php-fpm /usr/bin/php-fpm \
&& ln -s $PHP_DIR/bin/php /usr/bin/php \
&& ln -s $PHP_DIR/bin/phpize /usr/bin/phpize


 
#install redis extension
RUN curl https://codeload.github.com/phpredis/phpredis/zip/php7 -o /tmp/phpredis-php7.zip \
&& unzip /tmp/phpredis-php7.zip -d /tmp/ \
&& cd /tmp/phpredis-php7 \
&& phpize \
&& ./configure --with-php-config=$PHP_DIR/bin/php-config \
&& make -j "$(nproc)" \
&& make install \
&& make clean

#install xdebug extension
RUN curl https://codeload.github.com/xdebug/xdebug/zip/master -o /tmp/xdebug.zip \
&& unzip /tmp/xdebug.zip -d /tmp/ \
&& cd /tmp/xdebug-master \
&& phpize \
&& ./configure --enable-xdebug --with-php-config=$PHP_DIR/bin/php-config \
&& make -j "$(nproc)" \
&& cp modules/xdebug.so $PHP_DIR/lib/php/extensions/no-debug-non-zts-20151012/ \
&& make clean

#supervisor
RUN apt-get update && apt-get install -y supervisor --no-install-recommends -qqy && rm -r /var/lib/apt/lists/*


#generate few files
RUN touch $PHP_DIR/var/log/php-fpm.log \
&& rm -rf /tmp/*


EXPOSE 9000
ENTRYPOINT ["/bin/bash","start.sh"]