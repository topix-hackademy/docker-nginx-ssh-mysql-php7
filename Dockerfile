FROM ubuntu:16.04
MAINTAINER Alex Comunian <alex.comunian@gmail.com>

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl
RUN mkdir /var/run/sshd
RUN mkdir /run/php

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade

# Basic Requirements
RUN apt-get -y install pwgen python-setuptools curl git nano sudo unzip openssh-server openssl vim htop
RUN apt-get -y install mysql-server mysql-client nginx php-fpm php-mysql

# Node Installation
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN apt-get install -y build-essential

# NPM Task Manager
RUN npm install --global gulp-cli
RUN npm install -g grunt-cli

# PHP Requirements
RUN apt-get -y install php-xml php-mbstring php-bcmath php-zip php-pdo-mysql php-curl php-gd php-intl php-pear php-imagick php-imap php-mcrypt php-memcache php-apcu php-pspell php-recode php-tidy php-xmlrpc

# mysql config
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/explicit_defaults_for_timestamp = true\nbind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# nginx config
RUN sed -i -e"s/user\s*www-data;/user topix www-data;/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout\s*65/keepalive_timeout 2/" /etc/nginx/nginx.conf
RUN sed -i -e"s/keepalive_timeout 2/keepalive_timeout 2;\n\tclient_max_body_size 100m/" /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# php-fpm config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.0/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/7.0/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf
RUN sed -i -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" /etc/php/7.0/fpm/pool.d/www.conf
RUN sed -i -e "s/user\s*=\s*www-data/user = topix/g" /etc/php/7.0/fpm/pool.d/www.conf
# replace # by ; RUN find /etc/php/7.0/mods-available/tmp -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# nginx site conf
ADD ./nginx-site.conf /etc/nginx/sites-available/default

# Supervisor Config
RUN /usr/bin/easy_install supervisor
RUN /usr/bin/easy_install supervisor-stdout
ADD ./supervisord.conf /etc/supervisord.conf

# Add system user for topix
RUN useradd -m -d /home/topix -p $(openssl passwd -1 'topix') -G root -s /bin/bash topix \
    && usermod -a -G www-data topix \
    && usermod -a -G sudo topix \
    && ln -s /usr/share/nginx/www /home/topix/www

RUN mkdir /home/topix/site \
    && touch /home/topix/site/index.php \
    && echo "Hello World" > /home/topix/site/index.php \
    && mv /home/topix/site /usr/share/nginx/www

RUN chown -R topix:www-data /usr/share/nginx/www \
    && chmod -R 775 /usr/share/nginx/www

# Initialization and Startup Script
ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

#NETWORK PORTS
# private expose
EXPOSE 9011
EXPOSE 3306
EXPOSE 80
EXPOSE 22

# volume for mysql database and install
VOLUME ["/var/lib/mysql", "/usr/share/nginx/www", "/var/run/sshd"]

# Run
CMD ["/bin/bash", "/start.sh"]
