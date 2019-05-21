FROM php:5.4-apache

RUN echo "deb http://mirrors.linode.com/debian/ jessie main" > /etc/apt/sources.list

RUN apt-get update && \
    apt-get install --fix-missing -y \
      g++ \
      libfreetype6-dev \
      libgd-dev \
      vim \
      php-soap \
      libxml2 \
      php5-xsl \
      libxml2-dev \
      php5-xdebug \
      git \
      vim \
      php5-mysql \
      gearman \
      libgearman-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean all

RUN docker-php-ext-configure gd --with-freetype-dir=/usr
RUN docker-php-ext-install \
      mbstring \
      gd \
      exif \
      mysql \
      mysqli \
      pdo \
      pdo_mysql \
      zip \
      soap

RUN pecl install channel://pecl.php.net/xdebug-2.4.0 \
    gearman

RUN echo 'zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so' >> /usr/local/etc/php/php.ini && \
    echo 'extension = gearman.so' >> /usr/local/etc/php/php.ini

RUN a2enmod rewrite
