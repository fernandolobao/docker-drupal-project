# from https://www.drupal.org/requirements/php#drupalversions
FROM php:7.1-apache
MAINTAINER Fernando Camilotti "fernando.camilotti@hogarthww.com"

ADD . /app
RUN a2enmod rewrite
RUN apt-get update -yq
RUN apt-get install vim -y

# install the PHP extensions we need
RUN set -ex \
    && buildDeps=' \
    libjpeg62-turbo-dev \
    libpng-dev \
    libpq-dev \
    ' \
    && apt-get install -y --no-install-recommends $buildDeps && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd \
    --with-jpeg-dir=/usr \
    --with-png-dir=/usr \
    && docker-php-ext-install -j "$(nproc)" gd mbstring opcache pdo pdo_mysql pdo_pgsql zip \
    && apt-mark manual \
    libjpeg62-turbo \
    libpq5 \
    && apt-get purge -y --auto-remove $buildDeps

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini


# ## Configure APACHE with PHP mods
RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2enmod headers

RUN echo "include /app/.docker/site/apache2.conf" >> /etc/apache2/apache2.conf
RUN ln -sf /app/.docker/site/site-building.conf /etc/apache2/sites-enabled/site-building.conf

RUN curl -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y build-essential
RUN apt-get install -y git-all
RUN npm install -g grunt

ENV ALLOW_OVERRIDE **ALL**

RUN ln -sf /app/src /var/www/html

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80 443

RUN echo "===== INSTALL COMPOSER ======"
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_DISABLE_XDEBUG_WARN 1
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    composer self-update


RUN echo "===== CREATE DRUPAL PROJECT WITH COMPOSER ======"
RUN composer create-project drupal-composer/drupal-project:8.x-dev /app/src --stability dev --no-interaction
RUN echo "===== Listing dependencies ======"
RUN cd /app/src
# RUN composer require drupal/devel
RUN composer require drush/drush
#RUN composer require "drupal/features:~3.0"
# RUN composer require "drupal/bootstrap:~3.0"
# RUN composer require "drupal/ds:~3.0"
# RUN composer require "drupal/panels:~4.0"
# RUN composer require "drupal/bootstrap_layouts:~5.0"

RUN curl https://github.com/drush-ops/drush-launcher/releases/download/0.5.1/drush.phar > ./drush.phar 
RUN mv ./drush.phar /usr/local/bin/drush
RUN chmod +x /usr/local/bin/drush

### INSTALL Drush
#RUN ["/bin/bash", "-c", "bash < <(drush init)"]
#RUN drush init
#RUN drush self-update

WORKDIR /app
VOLUME ["/app"]
