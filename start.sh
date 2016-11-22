!/bin/bash

PRODUCTION=false
DB_NAME=something
DB_USER=something
# mysql setup
if [ ! -f /setup.txt ]; then
  #mysql has to be started this way as it doesn't work to call from /etc/init.d
  /usr/bin/mysqld_safe &
  sleep 10s

  if [ "$PRODUCTION" = true ] ; then
      MYSQL_PASSWORD=ROOTPSW
      APP_PASSWORD=APPPSW
  else
      MYSQL_PASSWORD=root
      APP_PASSWORD=local
  fi

  mysqladmin -u root password $MYSQL_PASSWORD
  mysql -uroot -p$MYSQL_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES;"
  mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE $DB_NAME; GRANT ALL PRIVILEGES ON $DB_NAME.* TO $DB_USER@'localhost' IDENTIFIED BY '$APP_PASSWORD'; FLUSH PRIVILEGES;"
  killall mysqld
fi

# start all the services
/usr/local/bin/supervisord -n -c /etc/supervisord.conf
