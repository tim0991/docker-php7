FROM php:7-fpm

RUN apt-get update && apt-get install -y  libpng-dev libjpeg-dev libpq-dev libfreetype6-dev vim \
libwebp-dev libjpeg62-turbo-dev libxpm-dev iputils-ping libmagickwand-dev libzip-dev libmcrypt-dev libonig-dev procps 

RUN docker-php-ext-install zip pdo_mysql pdo_pgsql pgsql exif mysqli bcmath mbstring \
    && printf "\n" | pecl install redis && docker-php-ext-enable redis \
    && pecl install msgpack && docker-php-ext-enable msgpack \
    && printf "\n" | pecl install swoole && docker-php-ext-enable swoole \
    && pecl install imagick-beta && docker-php-ext-enable imagick \
    && docker-php-ext-configure gd \
        --with-freetype=/usr/include/freetype2 \
        --with-jpeg=/usr/include \
    && docker-php-ext-install gd \
    && docker-php-ext-enable gd \
    && printf "\n" | pecl install mcrypt && docker-php-ext-enable mcrypt

RUN pecl install xdebug && docker-php-ext-enable xdebug 
COPY .bashrc /root/.bashrc
