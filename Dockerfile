FROM alpine:3.7

RUN apk update \ 
	&& apk add --no-cache \
	curl \
	nginx \
	php7 \
	php7-fpm \
	php7-phar \
	php7-json \
	php7-pdo \
	php7-pgsql \
	php7-pdo_pgsql \
	php7-openssl \
	php7-iconv \
	&& adduser -D -g 'www' www \
	&& mkdir -p /www \
	&& cd /www \
	&& php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
	&& php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
	&& php composer-setup.php \
	&& php -r "unlink('composer-setup.php');" \
	&& mv composer.phar /usr/local/bin/composer

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/nginx.vh.default.conf /etc/nginx/conf.d/default.conf
COPY conf/www.conf /etc/php7/php-fpm.d/www.conf
COPY scripts/start-services.sh /var/run/start-services.sh

ADD app/*.php /www/

RUN chown -R www:www /var/lib/nginx \
	&& chown -R www:www /www

EXPOSE 80

STOPSIGNAL SIGTERM

#CMD /bin/sh /var/run/start-services.sh