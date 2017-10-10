FROM debian:stretch
MAINTAINER Rick Guyer <ricoguyer@gmail.com>
# Borrowed from: https://registry.hub.docker.com/u/jprjr/ubuntu-php-fpm/dockerfile/
#           and: https://github.com/phpdocker-io/base-images/tree/master/php/7.0/fpm

ENV DEBIAN_FRONTEND noninteractive

#RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list && \
#    apt-get update && \
#    apt-get -y dist-upgrade

RUN apt-get update && apt-get --no-install-recommends -y install \
	php \
	php-fpm \
	php-gd \
	php-mysql \
	php-mcrypt \
	php-memcached \
	php-curl \
	&& apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# PHP-FPM packages need a nudge to make them docker-friendly
COPY overrides.conf /etc/php/7.0/fpm/pool.d/z-overrides.conf

# PHP-FPM has really dirty logs, certainly not good for dockerising
# The following startup script contains some magic to clean these up
COPY php-fpm-startup /usr/bin/php-fpm
RUN chmod 755 /usr/bin/php-fpm

RUN sed -i '/daemonize /c \
daemonize = no' /etc/php/7.0/fpm/php-fpm.conf

RUN mkdir -p /var/www && \
    echo "<?php phpinfo(); ?>" > /var/www/index.php && \
    chown -R www-data:www-data /var/www

EXPOSE 9000
VOLUME /var/www
ENTRYPOINT ["/usr/bin/php-fpm"]
