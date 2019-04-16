FROM phusion/baseimage:latest

MAINTAINER Andrei Susanu <andrei.susanu@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV DOCKERIZE_VERSION v0.6.1

# Add the "PHP 7" ppa
RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php

# install packages
RUN apt-get update && \
    apt-get -y --force-yes --no-install-recommends install \
    supervisor \
    nginx \
    php7.3-fpm \
    php7.3-cli \
    php7.3-common \
    php7.3-curl \
    php7.3-gd \
    php7.3-intl \
    php7.3-json \
    php7.3-mbstring \
    php7.3-mysql \
    php7.3-opcache \
    php7.3-pgsql \
    php7.3-soap \
    php7.3-sqlite3 \
    php7.3-xml \
    php7.3-xmlrpc \
    php7.3-xsl \
    php7.3-zip \
    php7.3-bcmath \
    php7.3-memcached \
    php7.3-dev \
    pkg-config \
    libcurl4-openssl-dev \
    libedit-dev \
    libssl-dev \
    libxml2-dev \
    xz-utils \
    libsqlite3-dev \
    sqlite3 \
    git \
    graphviz \
    curl \
    wget

# Install dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# configure NGINX as non-daemon
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# configure php-fpm as non-daemon
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.3/fpm/php-fpm.conf

# clear apt cache and remove unnecessary packages
RUN apt-get autoclean && apt-get -y autoremove

# NGINX mountable directories for config and logs
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx"]

# NGINX mountable directory for apps
VOLUME ["/var/www"]

# copy config file for Supervisor
COPY config/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# backup default default config for NGINX
RUN cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak

# copy local defualt config file for NGINX
COPY config/nginx/default /etc/nginx/sites-available/default

# php7.1-fpm will not start if this directory does not exist
RUN mkdir /run/php

# NGINX ports
EXPOSE 80 443

#####################################
# Composer:
#####################################

# Install composer and add its bin to the PATH.
RUN curl -s http://getcomposer.org/installer | php && \
    echo "export PATH=${PATH}:/var/www/vendor/bin" >> ~/.bashrc && \
    mv composer.phar /usr/local/bin/composer

# Source the bash
RUN . ~/.bashrc

CMD ["/usr/bin/supervisord"]
