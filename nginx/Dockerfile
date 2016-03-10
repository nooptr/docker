FROM    centos:centos6

MAINTAINER  thangnvbkhn@gmail.com

# install common packages
RUN     yum -y install wget curl sudo passwd

# install epel common for installing remi repo
RUN     yum -y install epel*

ADD     remi-release-6.rpm  /usr/local/src/remi-release-6.rpm
RUN     rpm -Uvh /usr/local/src/remi-release-6.rpm

COPY    nginx.repo  /etc/yum.repos.d/nginx.repo

RUN     yum -y install php php-fpm --enablerepo=remi-php56
RUN     yum -y install nginx

COPY    www.conf /etc/php-fpm.d/www.conf

RUN     rm -rf /etc/nginx/conf.d/default.conf
COPY    virtual.conf /etc/nginx/conf.d/virtual.conf


# start service
RUN     service nginx restart
RUN     chkconfig nginx on
RUN     service php-fpm restart
RUN     chkconfig php-fpm on
