FROM alpine:3.11.5

LABEL maintainer="Jeroen Ketelaar"

RUN apk add --update \
    curl \
    libssh2 \
    make \
    php7-fpm \
    php7-apcu \
    php7-ctype \
    php7-curl \
    php7-dom \
    php7-gd \
    php7-iconv \
    php7-imagick \
    php7-json \
    php7-intl \
    php7-mcrypt \
    php7-fileinfo\
    php7-mbstring \
    php7-opcache \
    php7-openssl \
    php7-pdo \
    php7-pdo_mysql \
    php7-mysqli \
    php7-xml \
    php7-xmlreader \
    php7-xmlwriter \
    php7-xsl \
    php7-zlib \
    php7-phar \
    php7-tokenizer \
    php7-session \
    php7-simplexml \
    php7-ssh2 \
    php7-xdebug \
    php7-zip

RUN rm -rf /var/cache/apk/* && rm -rf /tmp/* && \
    curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer

ADD config/www.ini /etc/php7/conf.d/
ADD config/www.ini /etc/php7/cli/conf.d/
ADD config/www.pool.conf /etc/php7/php-fpm.d/

CMD ["php-fpm7", "-F"]

WORKDIR /var/www/website
EXPOSE 9001
