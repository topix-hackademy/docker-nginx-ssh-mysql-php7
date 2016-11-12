#!/bin/bash

production=false

# mysql setup
if [ ! -f /setup.txt ]; then
  #mysql has to be started this way as it doesn't work to call from /etc/init.d
  /usr/bin/mysqld_safe &
  sleep 10s

  if [ "$production" = true ] ; then
      MYSQL_PASSWORD='ROOTPSW'
      APP_PASSWORD='APPPSW'
  else
      MYSQL_PASSWORD='LOCALROOTPSW'
      APP_PASSWORD='LOCALAPPPSW'
  fi

  mysqladmin -u root password $MYSQL_PASSWORD
  mysql -uroot -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;"
  mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE database_name; GRANT ALL PRIVILEGES ON database_name.* TO 'database_user'@'localhost' IDENTIFIED BY '$APP_PASSWORD'; FLUSH PRIVILEGES;"
  killall mysqld
fi

# start all the services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf