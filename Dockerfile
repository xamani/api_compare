FROM alpine:3.16

ARG ALPINE_VERSION=3.16

RUN echo http://dl-5.alpinelinux.org/alpine/v$ALPINE_VERSION/main > /etc/apk/repositories
RUN echo http://dl-5.alpinelinux.org/alpine/v$ALPINE_VERSION/community >> /etc/apk/repositories

# Install packages and remove default server definition
RUN apk --no-cache add php81 \
    php81-common \
    php81-fpm \
    php81-pdo \
    php81-opcache \
    php81-zip \
    php81-phar \
    php81-iconv \
    php81-cli \
    php81-curl \
    php81-openssl \
    php81-mbstring \
    php81-tokenizer \
    php81-fileinfo \
    php81-json \
    php81-xml \
    php81-xmlwriter \
    php81-simplexml \
    php81-dom \
    php81-pdo_mysql \
    php81-pdo_sqlite \
    php81-tokenizer \
    php81-pecl-redis \
    php81-posix \
    php81-pcntl \
    nginx supervisor curl tzdata nano git git-flow vim redis htop mysql-client

# Install additional php extentions and remove default server definition
RUN apk add --no-cache php81-bcmath \
    php81-ctype \
    php81-gmp \
    php81-gd \
    php81-iconv \
    php81-simplexml \
    php81-xmlreader \
    php81-zlib \
    php81-intl \
    php81-ctype

RUN apk add --progress \
           bash \
           libpng-dev \
           gcc \
           g++ \
           make \
           nodejs \
           npm

# Symlink php81 => php
RUN ln -s /usr/bin/php81 /usr/bin/php

# Install PHP tools
COPY --from=composer:2.3 /usr/bin/composer /usr/local/bin/composer

# Configure nginx
COPY docker/development/config/nginx.conf /etc/nginx/nginx.conf

# Configure PHP-FPM
COPY docker/development/config/fpm-pool.conf /etc/php81/php-fpm.d/www.conf
COPY docker/development/config/php.ini /etc/php81/conf.d/custom.ini

# Configure supervisord
COPY docker/development/config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN set -x \
	&& adduser -u 1000 -D -S -G www-data www-data

# Setup document root
RUN mkdir -p /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R www-data.www-data /var/www/html && \
  chown -R www-data.www-data /run && \
  chown -R www-data.www-data /var/lib/nginx && \
  chown -R www-data.www-data /var/log/nginx

# Switch to use a non-root user from here on
USER www-data

# Add application
WORKDIR /var/www/html
COPY --chown=www-data ./ /var/www/html/

RUN chmod 777 -R storage/ \
 && chmod 777 -R bootstrap/cache/ \
 && chmod 755 docker/docker-entrypoint.sh

#Install php dependency
RUN composer install --no-dev --no-suggest --no-autoloader

# Expose the port nginx is reachable on
EXPOSE 80

# Define the entry point that tries to enable newrelic
ENTRYPOINT ["docker/docker-entrypoint.sh"]
