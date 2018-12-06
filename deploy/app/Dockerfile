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
	supervisor \
	nginx \
	mysql-client \
	policycoreutils \
	software-properties-common  \
	&& add-apt-repository -y ppa:libreoffice/ppa \
	&& apt-get install -y libreoffice \
	&& apt-get install -y fonts-takao-mincho \
	&& apt-get install -y sudo

#RUN apt-get install -y software-properties-common
#RUN add-apt-repository -y ppa:libreoffice/ppa
#RUN apt-get install -y libreoffice
#RUN apt-get install -y ^fonts-*

ADD ./deploy/app/conf/nginx.conf /etc/nginx/sites-available/default
ADD ./deploy/app/conf/supervisord.conf /etc/supervisord.conf
ADD ./deploy/app/script/start.sh /tmp/start.sh
ADD ./deploy/app/sql/initdb.sql /tmp/initdb.sql
ADD ./deploy/app/script/initialize.sh /tmp/initialize.sh
ADD ./deploy/ssl-cert/qadoc.pem /opt/qa-app/ssl-cert/qadoc.pem
ADD ./deploy/ssl-cert/qadoc.key /opt/qa-app/ssl-cert/qadoc.key
CMD ["/bin/bash", "/tmp/start.sh"]

#RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*
	
COPY ./deploy/app/php-ini-overrides.ini /etc/php/7.1/fpm/conf.d/99-overrides.ini
COPY ./deploy/app/ImageMagick.xml /etc/ImageMagick-6/policy.xml
ADD ./owncloud /var/www/owncloud
RUN chmod -R 777 /var/www/owncloud/config
RUN chown www-data:www-data /var/www/owncloud/config/config.php
WORKDIR "/var/www"
