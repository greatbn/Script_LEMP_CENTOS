#!/bin/bash
echo "--------------------------------------------------------"
echo "----------------------Waiting update--------------------"
echo "--------------------------------------------------------"
yum -y update
echo "--------------------------------------------------------"
echo "------------Install repo required-----------------------"
echo "--------------------------------------------------------"
rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
yum -y install epel-release
echo "\n"
echo "--------------------------------------------------------"
echo "-------------Installing  MySQL--------------------------"
echo "--------------------------------------------------------"
yum --enablerepo=remi,remi-test install mysql mysql-server -y
echo "--------------------------------------------------------"
echo "-------------Configure MySQL----------------------------"
echo "--------------------------------------------------------"
service mysqld start
mysql_secure_installation
echo "--------------------------------------------------------"
echo "-------------Install nginx and php-fpm----------------- "
echo "--------------------------------------------------------"
python  -c 'print "[nginx]\nname=nginx repo\nbaseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/\ngpgcheck=0\nenabled=1" ' >> /etc/yum.repos.d/nginx.repo
yum --enablerepo=remi,remi-php56 install nginx php-fpm php-mysql php-common php-mbstring php-mcrypt php-gd -y
echo "--------------------------------------------------------"
echo "---------------------Install phpMyAdmin-----------------"
echo "--------------------------------------------------------"
yum --enablerepo=remi,remi-php56 install phpMyAdmin -y
yum --enablerepo=remi,remi-php56 install php-mbstring -y
ln -s /usr/share/phpMyAdmin /usr/share/nginx/html
chown -R nginx:nginx /var/lib/php/session/
sed -i 's/'
echo "--------------------------------------------------------"
echo "---------------------Start service----------------------"
echo "--------------------------------------------------------"
service nginx restart
service php-fpm restart
service mysqld restart
chkconfig mysqld on
chkconfig php-fpm on
chkconfig nginx on