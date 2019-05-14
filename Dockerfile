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
      php5-mysql && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get clean all

# enable mod_rewrite

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

RUN pecl install apc-3.1.13; \
  echo "extension=/usr/local/lib/php/extensions/no-debug-non-zts-20100525/apc.so" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN pecl install channel://pecl.php.net/xdebug-2.4.0; \
  echo 'zend_extension = /usr/local/lib/php/extensions/no-debug-non-zts-20100525/xdebug.so' >> /usr/local/etc/php/php.ini; \
  touch /usr/local/etc/php/conf.d/xdebug.ini && \
    echo xdebug.remote_enable=1 >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo xdebug.remote_autostart=1 >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo xdebug.remote_connect_back=0 >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo xdebug.remote_host=docker.for.win.localhost >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo xdebug.remote_handler=dbgp >> /usr/local/etc/php/conf.d/xdebug.ini && \
    echo xdebug.remote_port=9000 >> /usr/local/etc/php/conf.d/xdebug.ini

RUN a2enmod rewrite
