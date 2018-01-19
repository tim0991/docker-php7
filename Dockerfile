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
    libfreetype6-dev \
    libkrb5-dev \
    libicu-dev \
    libxslt1-dev \
    xz-utils \
    unzip \
    vim \
    netcat \
    redis-tools \
    mysql-client \
    git \
    supervisor \
    ssh \
    --no-install-recommends -qqy  && rm -r /var/lib/apt/lists/*

ENV PHP_VERSION php-7.2.1
ENV PHP_DIR /usr/local/php

#install php7
RUN curl http://uk1.php.net/distributions/${PHP_VERSION}.tar.xz -o /tmp/${PHP_VERSION}.tar.xz  \
&& tar -xvJf /tmp/${PHP_VERSION}.tar.xz -C /tmp/ \
&& cd /tmp/${PHP_VERSION} \
&& ./configure -prefix=$PHP_DIR \
    --with-config-file-path=$PHP_DIR/etc \
    --with-config-file-scan-dir=$PHP_DIR/etc/conf.d \
    -with-iconv --enable-mbstring \
    -with-mcrypt --with-zlib --enable-zip \
    -with-gd -enable-gd-native-ttf --with-jpeg-dir --with-png-dir --with-freetype-dir \
    -enable-fpm --with-fpm-user=www-data --with-fpm-group=www-data \
    -with-openssl -enable-pcntl -enable-sockets -with-xmlrpc  -with-curl -enable-opcache \
    -enable-mysqlnd -with-pdo-mysql  -with-mysqli \
    --with-imap --with-imap-ssl --with-kerberos --enable-intl --with-xsl \
&& make -j "$(nproc)" \
&& make install \
&& make clean \
&& mv $PHP_DIR/etc/php-fpm.conf.default $PHP_DIR/etc/php-fpm.conf \
&& ln -s $PHP_DIR/sbin/php-fpm /usr/bin/php-fpm \
&& ln -s $PHP_DIR/bin/php /usr/bin/php \
&& ln -s $PHP_DIR/bin/phpize /usr/bin/phpize

#install xsl ext
RUN cd /tmp/${PHP_VERSION}/ext/xsl && phpize && ./configure --with-php-config=$PHP_DIR/bin/php-config  && make \
&& cp modules/xsl.so $PHP_DIR/lib/php/extensions/no-debug-non-zts-20170718/


 
#install redis extension
RUN cd /tmp/ && git clone https://github.com/phpredis/phpredis.git redis \
&& cd redis \
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
&& cp modules/xdebug.so $PHP_DIR/lib/php/extensions/no-debug-non-zts-20170718/ \
&& make clean


#add composer
RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && chmod a+x /usr/local/bin/composer

#generate few files and configure .bashrc
RUN touch $PHP_DIR/var/log/php-fpm.log \
&& rm -rf /tmp/* && echo 'alias ll="ls -alh"' >> /root/.bashrc


EXPOSE 9000
ENTRYPOINT ["/bin/bash","start.sh"]