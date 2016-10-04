# docker-nginx-ssh-mysql-php7
Docker Container for NGINX / PHP7 / MYSQL / SSH

A Dockerfile that installs the latest Ubuntu 16.04 with nginx 1.10.0, php-fpm7.0, php7.0 APC User Cache and openssh. You can also handle the services using supervisord.

## Installation

The easiest way get up and running with this docker container is to pull the latest stable version from the [Docker Hub Registry](https://hub.docker.com/r/alexcomu/docker-nginx-ssh-mysql-php7/):

```bash
$ docker pull alexcomu/docker-nginx-ssh-mysql-php7/:latest
```

If you'd like to build the image yourself:

```bash
$ git clone https://github.com/alexcomu/docker-nginx-ssh-mysql-php7.git
$ cd docker-nginx-ssh-mysql-php7
$ sudo docker build -t="alexcomu/docker-nginx-ssh-mysql-php7/" .
```

## Usage

The -p 8000:80 maps the internal docker port 80 to the outside port 80 of the host machine. The other -p sets up sshd on port 7000.
The -p 9011:9011 is using for supervisord, listing out all services status.
```bash
$ sudo docker run -p 7000:22 -p 8000:80 --name CONTAINER_NAME -h CONTAINER_NAME -d alexcomu/docker-nginx-ssh-mysql-php7:latest
```

Start your newly created container, named *docker-name*.

```
$ sudo docker start CONTAINER_NAME
```

After starting the container docker-wordpress-nginx-ssh checks to see if it has started and the port mapping is correct.  This will also report the port mapping between the docker container and the host machine.

```
$ sudo docker ps

3306/tcp, 0.0.0.0:9011->9011/tcp, 0.0.0.0:7000->22/tcp, 0.0.0.0:8000->80/tcp
```

You can then visit the following URL in a browser on your host machine to get started:

```
http://127.0.0.1:8000
```

You can start/stop/restart and view the error logs of nginx and php-fpm services:
```
http://127.0.0.1:9011
```

You can also SSH to your container on 127.0.0.1:7000. The default password is *topix*, and can also be found in .ssh-default-pass.

```
$ ssh -p 7000 topix@127.0.0.1
# To drop into root
$ sudo -s
```

Now that you've got SSH access, you can setup your FTP client the same way, or the SFTP Sublime Text plugin, for easy access to files.

To get the MySQL's password, check the top of the docker container logs for it:

```
$ docker logs <container-id>
```
or ssh to your container and view those files:
```
$ cat /mysql-root-pw.txt
```
