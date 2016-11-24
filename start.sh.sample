!/bin/bash

PRODUCTION=false

# mysql setup
if [ ! -f /setup.txt ]; then
  #mysql has to be started this way as it doesn't work to call from /etc/init.d
  /usr/bin/mysqld_safe &
  sleep 10s

  if [ "$PRODUCTION" = true ] ; then
      DB_NAME=YOUR_APP_SERVER_DB_NAME
      DB_USER=YOUR_APP_SERVER_DB_USER
      MYSQL_PASSWORD=YOUR_ROOT_SERVER_DB_PASSWORD
      APP_PASSWORD=YOUR_SERVER_DEVELOPMENT_DB_PASSWORD
  else
      DB_NAME=YOUR_APP_LOCAL_DB_NAME
      DB_USER=YOUR_APP_LOCAL_DB_USER
      MYSQL_PASSWORD=YOUR_ROOT_DEVELOPMENT_DB_PASSWORD
      APP_PASSWORD=YOUR_ENV_DEVELOPMENT_DB_PASSWORD
  fi

  mysqladmin -u root password $MYSQL_PASSWORD
  mysql -uroot -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;"
  mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE $DB_NAME; GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'localhost' IDENTIFIED BY '$APP_PASSWORD'; FLUSH PRIVILEGES;"
  killall mysqld
fi

# start all the services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf
