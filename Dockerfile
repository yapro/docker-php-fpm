FROM debian:wheezy

MAINTAINER Ilya Epifanov <elijah.epifanov@gmail.com>

ENV PHP_VERSION=5.5.24

COPY dotdeb.gpg /tmp/dotdeb.gpg
RUN apt-key add /tmp/dotdeb.gpg
RUN echo 'deb http://packages.dotdeb.org wheezy-php55 all' > /etc/apt/sources.list.d/dotdeb.list

RUN apt-get update &&\
    apt-get install -y \
     "php5-fpm=$PHP_VERSION-*" \
     --no-install-recommends &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /var/www/ /etc/php5

CMD ["php5-fpm"]
