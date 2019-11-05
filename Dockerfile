FROM php:7-fpm

RUN apt-get update && apt-get install -y  libpng-dev libjpeg-dev libpq-dev libfreetype6-dev vim \
libwebp-dev libjpeg62-turbo-dev libxpm-dev iputils-ping libmagickwand-dev

RUN docker-php-ext-install gd pdo_mysql pdo_pgsql pgsql exif mysqli bcmath mbstring \
    && printf "\n" | pecl install redis && docker-php-ext-enable redis \
    && pecl install msgpack && docker-php-ext-enable msgpack \
    && printf "\n" | pecl install swoole && docker-php-ext-enable swoole \
    && pecl install imagick-beta && docker-php-ext-enable imagick 


RUN docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir \
    --with-png-dir --with-zlib-dir --with-xpm-dir --with-freetype-dir \
    && docker-php-ext-install gd 
    
COPY .bashrc /root/.bashrc
