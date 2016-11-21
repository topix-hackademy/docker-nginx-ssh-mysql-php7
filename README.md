# docker-nginx-ssh-mysql-php7
Docker Container for NGINX / PHP7 / MYSQL / NPM - Laravel Development

A Dockerfile that installs the latest Ubuntu 16.04 with nginx 1.10.0, php-fpm7.0, php7.0 APC User Cache, openssh and NPM. You can also handle the services using supervisord.

## Installation
Before build the image yourself edit:

    - Dockerfile
    - start.sh

changing the PARMAS as you want

```bash
$ git clone https://github.com/andreafspeziale/docker-nginx-mysql-php7-npm.git
$ cd docker-nginx-mysql-php7-npm
$ sudo docker build -t="SOMENAME" .
(For instance sudo docker build -t="NAMEOFYOURAPP/docker-nginx-mysql-php7-npm" .)
```

## Usage if you already have a Laravel App

The -p 8000:80 maps the internal docker port 80 to the outside port 80 of the host machine. The other -p sets up sshd on port 7000.
The -p 9011:9011 is using for supervisord, listing out all services status.

```bash
$ sudo docker run -v local_application_path:/usr/share/nginx/www -p 7000:22 -p 8000:80 --name CONTAINER_NAME -h CONTAINER_NAME -d NAMEOFYOURAPP/docker-nginx-mysql-php7-npm
```
Install your app dependencies edit your .env, make migrations anche check if everything works at localhost:8000!
