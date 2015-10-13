FROM debian:wheezy

MAINTAINER Ilya Epifanov <elijah.epifanov@gmail.com>

ENV PHP_VERSION=5.5.30

RUN apt-get update \
 && apt-get install -y curl software-properties-common python-software-properties \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -s http://www.dotdeb.org/dotdeb.gpg | apt-key add -

RUN echo 'deb http://packages.dotdeb.org wheezy-php55 all' > /etc/apt/sources.list.d/dotdeb.list
RUN echo "deb http://ftp.de.debian.org/debian wheezy-backports main" >> /etc/apt/sources.list

RUN apt-get update \
 && apt-get install -y "php5-cli=$PHP_VERSION-*" "php5-fpm=$PHP_VERSION-*" "php5-curl=$PHP_VERSION-*" "php5-mysqlnd=$PHP_VERSION-*" "php5-pgsql=$PHP_VERSION-*" "php5-gd=$PHP_VERSION-*" php5-mongo php5-memcache php5-apcu "php5-intl=$PHP_VERSION-*" php5-imagick php5-mcrypt --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV AEROSPIKE_VERSION=3.4.2

RUN curl -sL --raw https://github.com/aerospike/aerospike-client-php/archive/${AEROSPIKE_VERSION}.tar.gz -o /tmp/aerospike.tar.gz \
 && mkdir /tmp/aerospike \
 && tar zxf /tmp/aerospike.tar.gz --strip-components=1 -C /tmp/aerospike \
 && cd /tmp/aerospike/src/aerospike \
 && apt-get update \
 && apt-get install -y build-essential autoconf libssl-dev liblua5.1-dev "php5-dev=$PHP_VERSION-*" "php-pear=$PHP_VERSION-*" --no-install-recommends \
 && ./build.sh \
 && make install \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV PATH=/usr/local/bin:/bin:/usr/bin

RUN echo 'date.timezone = UTC' > /etc/php5/fpm/conf.d/99-timezone.ini
RUN echo 'date.timezone = UTC' > /etc/php5/cli/conf.d/99-timezone.ini
ADD aerospike.ini /etc/php5/fpm/conf.d/99-aerospike.ini
ADD aerospike.ini /etc/php5/cli/conf.d/99-aerospike.ini

CMD ["/usr/sbin/php5-fpm", "-F"]
