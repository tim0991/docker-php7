FROM php:7-fpm

# RUN echo 'deb http://mirrors.aliyun.com/debian stretch main contrib non-free\
# deb http://mirrors.aliyun.com/debian stretch-proposed-updates main contrib non-free\
# deb http://mirrors.aliyun.com/debian stretch-updates main contrib non-free\
# deb-src http://mirrors.aliyun.com/debian stretch main contrib non-free\
# deb-src http://mirrors.aliyun.com/debian stretch-proposed-updates main contrib non-free\
# deb-src http://mirrors.aliyun.com/debian stretch-updates main contrib non-free\
# deb http://mirrors.aliyun.com/debian-security/ stretch/updates main non-free contrib\
# deb-src http://mirrors.aliyun.com/debian-security/ stretch/updates main non-free contrib' > /etc/apt/sources.list

RUN apt-get update && apt-get install -y  libpng-dev libjpeg-dev libpq-dev libfreetype6-dev

RUN docker-php-ext-install gd pdo_pgsql pgsql exif \
    && printf "\n" | pecl install redis && docker-php-ext-enable redis

RUN docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-freetype-dir=/usr/include/freetype2 \
        --with-png-dir=/usr/include \
        --with-jpeg-dir=/usr/include \
    && docker-php-ext-install gd \
    && docker-php-ext-install mbstring \
    && docker-php-ext-enable gd

RUN apt-get update && apt-get install libmagickwand-dev -y && pecl install imagick-beta \
    && docker-php-ext-enable imagick \
    && apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
COPY .bashrc /root/.bashrc
