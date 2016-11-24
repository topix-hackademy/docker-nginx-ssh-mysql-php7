#!/bin/bash

# env
PRODUCTION=false

# color
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# var
SSH_PORT=7002
APP_PORT=8002
MYSQL_PORT=9000

APP_NAME=NAME_FOR_YOUR_APP
BUILD=NAME_FOR_YOUR_BUILD
REPOSITORY=https://username@bitbucket.org/something..

HOST_PROJECT_PATH=$(pwd)/$APP_NAME

# clone
if [ ! -d "$HOST_PROJECT_PATH" ]; then
    echo -e ${GREEN}Cloning $APP_NAME repository start${NC}
    git clone $REPOSITORY $APP_NAME
else
    echo -e ${GREEN}Repository $APP_NAME already cloned${NC}
fi

# startup container
echo -e ${GREEN}Docker build${NC}
docker build -t="$BUILD" .

# run container
echo -e ${GREEN}Running container${NC}
docker run -v $HOST_PROJECT_PATH:/usr/share/nginx/www -p $SSH_PORT:22 -p $APP_PORT:80 -p $MYSQL_PORT:3306 --name $APP_NAME -h $APP_NAME -d $BUILD
sleep 30

# remote host
echo -e ${GREEN}Login container${NC}
ssh topix@localhost -p $SSH_PORT <<'ENDSSH'

PRODUCTION=false

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

PROJECT_FOLDER=/usr/share/nginx/www
CHECK_NODE_MODULES_DIRECTORY=/usr/share/nginx/www/node_modules
CHECK_VENDOR_DIRECTORY=/usr/share/nginx/www/vendor
ENV_FILE=/usr/share/nginx/www/.env

# check if path exist
if [ ! -d "$CHECK_VENDOR_DIRECTORY" ]; then
    echo -e ${RED}Composer vendor are not installed${NC}
    cd $PROJECT_FOLDER
    composer install
    echo -e ${GREEN}Composer vendor installed${NC}
else
    echo -e ${GREEN}Composer vendor exist${NC}
fi

if [ ! -d "$CHECK_NODE_MODULES_DIRECTORY" ]; then
    echo -e ${RED}Node modules are not installed${NC}
    cd $PROJECT_FOLDER
    npm install
    echo -e ${GREEN}Node modules installed${NC}
else
    echo -e ${GREEN}Node modules are installed${NC}
fi

if [ ! -f "$ENV_FILE" ]; then
    echo -e ${RED}.env file does not exist${NC}
    cd $PROJECT_FOLDER
    echo -e ${GREEN}Creating .env${NC}
    if [ "$PRODUCTION" = true ] ; then
        # set .env for production
        echo -e ${GREEN}.env production ready${NC}
    else
        # set .env for development
        cp .env.development .env
        echo -e ${GREEN}.env development ready${NC}
    fi
    # set APP_KEY of .env file
    echo -e ${GREEN}Creating APP_KEY${NC}
    php artisan key:generate
else
    echo -e ${GREEN}.env exist${NC}
fi

# make migrations
echo -e ${GREEN}Make migration${NC}
cd $PROJECT_FOLDER
php artisan migrate --seed
gulp

ENDSSH
