FROM ubuntu:16.04

MAINTAINER Ilya Epifanov <elijah.epifanov@gmail.com>

ENV PHP_VERSION=5.6.17

RUN apt-get update \
 && apt-get install -y curl ca-certificates software-properties-common python-software-properties \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.6/gosu-$(dpkg --print-architecture)" \
        && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.6/gosu-$(dpkg --print-architecture).asc" \
        && gpg --verify /usr/local/bin/gosu.asc \
        && rm /usr/local/bin/gosu.asc \
        && chmod +x /usr/local/bin/gosu

RUN curl -s http://www.dotdeb.org/dotdeb.gpg | apt-key add -

RUN echo 'deb http://cz.archive.ubuntu.com/ubuntu wily main universe' >> /etc/apt/sources.list

RUN apt-get update \
 && apt-get install -y tzdata locales-all "php5-cli=$PHP_VERSION+*" "php5-fpm=$PHP_VERSION+*" "php5-curl=$PHP_VERSION+*" "php5-mysqlnd=$PHP_VERSION+*" "php5-pgsql=$PHP_VERSION+*" "php5-gd=$PHP_VERSION+*" php5-mongo php5-memcache php5-apcu "php5-intl=$PHP_VERSION+*" php5-xdebug php5-imagick php5-mcrypt --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH=/usr/local/bin:/bin:/usr/bin

RUN echo 'date.timezone = UTC' > /etc/php5/fpm/conf.d/00-timezone.ini
RUN echo 'date.timezone = UTC' > /etc/php5/cli/conf.d/00-timezone.ini

CMD ["/usr/sbin/php5-fpm", "-F"]
