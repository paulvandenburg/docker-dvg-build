FROM composer:1.9.0

ENV LANG C.UTF-8

# Install yarn.
RUN apk update \
 && apk upgrade \
 && apk add --no-cache yarn \
 && rm -rf /var/cache/apk/*

# Add additionally required PHP extensions.
RUN apk add --no-cache freetype-dev libjpeg-turbo-dev libpng-dev libwebp-dev \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install -j$(nproc) gd \
 && rm -rf /var/cache/apk/*

# Disable php short_open_tag
RUN echo 'short_open_tag=Off' >> /usr/local/etc/php/php-cli.ini

# Install drush.
RUN mkdir /opt/drush \
 && echo '{ \
    "require": { \
        "drush/drush": "8.*" \
    }, \
    "config": { \
        "bin-dir": "/usr/local/bin" \
    } \
}' > /opt/drush/composer.json \
 && cd /opt/drush \
 && composer install \
 && composer clear-cache

WORKDIR "/build"

VOLUME /build
