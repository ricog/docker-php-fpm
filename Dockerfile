FROM debian:wheezy
MAINTAINER Rick Guyer <ricoguyer@gmail.com>
# Borrowed from https://registry.hub.docker.com/u/jprjr/ubuntu-php-fpm/dockerfile/

ENV DEBIAN_FRONTEND noninteractive

#RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list && \
#    apt-get update && \
#    apt-get -y dist-upgrade

RUN apt-get update
RUN apt-get --no-install-recommends -y install php5 php5-fpm php5-gd php5-mysql php5-mcrypt php5-memcached php5-curl

RUN sed -i '/daemonize /c \
daemonize = no' /etc/php5/fpm/php-fpm.conf

RUN sed -i '/^listen /c \
listen = 0.0.0.0:9000' /etc/php5/fpm/pool.d/www.conf

RUN sed -i 's/^listen.allowed_clients/;listen.allowed_clients/' /etc/php5/fpm/pool.d/www.conf

RUN mkdir -p /var/www && \
    echo "<?php phpinfo(); ?>" > /var/www/index.php && \
    chown -R www-data:www-data /var/www

EXPOSE 9000
VOLUME /var/www
ENTRYPOINT ["php5-fpm"]

