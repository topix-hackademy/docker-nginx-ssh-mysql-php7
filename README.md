# docker-nginx-ssh-mysql-php7-npm for Laravel Development
Docker Container for NGINX / PHP7 / MYSQL / SSH / NODE

A Dockerfile that installs the latest Ubuntu 16.04 with nginx 1.10.0, php-fpm7.0, php7.0 APC User Cache and openssh
 
It install also all the front-end requirements and your app itself if you are not starting from scratch

You can also handle the services using supervisord

##Req

Docker for mac, download [here](https://docs.docker.com/docker-for-mac/ "Docker for mac download")

## Advises
Set the docker resources preferences to more than 2CPU and 2Gb of RAM

You can set it from docker preferences panel

Set variables

```
Create in your laravel application an .env.development and 
set the DB connection info in the start.sh script
```

## Notes
The complete installation will take at least 10 minutes

## Preferences
You can actually decide which port Docker will map on your machine by simply editing the install script
```
SSH_PORT=7002
APP_PORT=8002
MYSQL_PORT=9000
```

```
APP_NAME=NAME_FOR_YOUR_APP
BUILD=NAME_FOR_YOUR_BUILD
REPOSITORY=https://github.com/andreafspeziale/project-flyer (for instance)
```

## Installation for Local Development
Clone the repository set install var and run

```
$ bash install.sh
```

The script will prompt you just twice:
```
- The first time for repository git clone.
- The second time for Docker container ssh login (psw topix).
```

The script will also handle .env configuration file, vendors and migrations


When it finish, visit on your browser localhost:8002


You can alsol log into the container with ssh topix@localhost -p $SSH_PORT (psw topix)

## Development notes
The install script and with a gulp watch so you will be able to start developing directly on your machine with your favorite IDE and see live changes on your browser
You can stop the container with

```
$ docker stop APP_NAME (set in install.sh)
```

and start it again with

```
$ docker start APP_NAME (set in install.sh) (remember to log into the container and run gulp watch)
```
