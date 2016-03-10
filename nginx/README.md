Docker Ops for nginx
==========

Usage
-----

Make Docker image from Dockerfile for nginx:
```sh
$ cd ~/project/docker/nginx
$ docker build -t centos6_nginx ./
```

Make Docker container from Docker image with web port is 9090, ssh port is 40022
```sh
$ docker run -h apdev.local -it --name "nginx_test" -p 9090:80 -p 40022:22 centos6_nginx /bin/bash
```

Get ip address of docker:

```sh
$ docker-machine ip default
192.168.99.100
```

Register ip address 192.168.99.100 for test.apdev.local to /etc/hosts at localhost:
```sh
$ cat /etc/hosts
192.168.99.100 test.apdev.local
```

Check services running or not:

```sh
$ curl http://test.apdev.local
```
