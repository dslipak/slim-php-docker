#!/bin/sh

php-fpm7 -D
nginx -g "daemon off;"
cd /www && composer require slim/slim "^3.0"