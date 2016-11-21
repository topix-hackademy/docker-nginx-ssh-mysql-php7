FROM alexcomu/docker-nginx-ssh-mysql-php7

# Node Installation
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN apt-get install -y build-essential

# NPM Task Manager
RUN npm install --global gulp-cli
RUN npm install -g grunt-cli

#PHP Addition
RUN apt-get -y install php*-ldap

# Composer Installation
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
