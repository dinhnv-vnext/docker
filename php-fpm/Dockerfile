FROM phpdockerio/php71-fpm:latest

RUN apt-get update -y && \
	apt-get -y install -y \ 
	php-memcached \
	php7.1-intl \
	php7.1-mysql \
	php7.1-gd \
	php-redis \
	php-ssh2 \
	php7.1-mbstring \
	php7.1-dev \
	php-imagick \
	imagemagick \	
	make \
	wget \
	unzip \	
	mysql-client \
	policycoreutils

RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:libreoffice/ppa
RUN apt-get install -y libreoffice

#RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
	
COPY php-ini-overrides.ini /etc/php/7.1/fpm/conf.d/99-overrides.ini
WORKDIR "/var/www"
