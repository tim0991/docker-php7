FROM php:7-fpm

# RUN echo 'deb http://mirrors.aliyun.com/debian stretch main contrib non-free\
# deb http://mirrors.aliyun.com/debian stretch-proposed-updates main contrib non-free\
# deb http://mirrors.aliyun.com/debian stretch-updates main contrib non-free\
# deb-src http://mirrors.aliyun.com/debian stretch main contrib non-free\
# deb-src http://mirrors.aliyun.com/debian stretch-proposed-updates main contrib non-free\
# deb-src http://mirrors.aliyun.com/debian stretch-updates main contrib non-free\
# deb http://mirrors.aliyun.com/debian-security/ stretch/updates main non-free contrib\
# deb-src http://mirrors.aliyun.com/debian-security/ stretch/updates main non-free contrib' > /etc/apt/sources.list

RUN apt-get update && apt-get install -y  libpng-dev libjpeg-dev libpq-dev

RUN docker-php-ext-install gd pdo_pgsql pgsql bcmath \
    && printf "\n" | pecl install redis && docker-php-ext-enable redis

COPY .bashrc /root/.bashrc
