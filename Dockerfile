FROM php:7.3-fpm

RUN apt-get update
RUN apt-get install -y --no-install-recommends libxml2-dev
RUN apt-get install -y libmagickwand-dev libmagickcore-dev libmagickwand-dev libcurl3-dev curl libxslt-dev unzip git

RUN pecl channel-update pecl.php.net
RUN pecl install imagick >/dev/null 2>&1 || { retVal=$?; true; }
RUN docker-php-ext-enable imagick
RUN pecl install xdebug-2.7.0RC2  >/dev/null 2>&1 || { retVal=$?; true; }
RUN docker-php-ext-enable xdebug

RUN pecl install swoole
RUN docker-php-ext-enable swoole

WORKDIR /usr/src/
RUN git clone -b php7 https://github.com/alexeyrybak/blitz.git
WORKDIR blitz
RUN phpize && ./configure && make && make install
RUN docker-php-ext-enable blitz
WORKDIR /usr/src
RUN rm -rf blitz

RUN docker-php-ext-install xsl intl sockets bcmath pdo pdo_mysql mysqli soap
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -Ls https://phar.phpunit.de/phpunit-skelgen.phar --output phpunit-skelgen.phar
RUN chmod +x phpunit-skelgen.phar
RUN mv phpunit-skelgen.phar /usr/local/bin/phpunit-skelgen

RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps
