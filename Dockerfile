FROM php:7.2-fpm-stretch

MAINTAINER Leonardo Gomes da Silva <leonardo.delfica@gmail.com>

ARG UNAME=docker
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID -o $UNAME
RUN useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME

#Instaling my-sql driver and other things
RUN apt-get update && apt-get install -y libpng-dev libjpeg-dev libpq-dev libldap2-dev mysql-client zip git wget\
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql pcntl

#Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

USER $UNAME

#Create a directory to run the app
RUN mkdir -p /var/www/html/

#Set this directory as our working directory
WORKDIR /var/www/html/

#Copy the content to the working directory
#not using because using as volumes!
#COPY . /var/www/html/

#Composer install
#RUN composer install --no-dev

#Our app runs on port 9000. Expose this port!
EXPOSE 9000

#Run the application.
CMD ["php-fpm"]
