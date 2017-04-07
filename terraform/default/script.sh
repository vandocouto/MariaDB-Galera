#!/bin/bash

# configure ebs disk
sudo mkfs.ext4 /dev/xvdb
sudo mkdir -p /var/lib/mysql
sudo sed -i s/'\/mnt'/'\/var\/lib\/mysql'/g /etc/fstab
sudo mount -a

if [ ! -d "/var/lib/mysql/lost+found/" ]; then
    exit 1
fi

# configure repository mariadb-server
sudo apt-get update -y
sudo apt-get install software-properties-common rsync python-simplejson python-mysqldb -y
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirror.ufscar.br/mariadb/repo/10.1/ubuntu xenial main'
sudo apt update -y

# install mariadb-server
sudo export DEBIAN_FRONTEND=noninteractive
sudo debconf-set-selections <<< 'mariadb-server-10.1 mysql-server/root_password password pass'
sudo debconf-set-selections <<< 'mariadb-server-10.1 mysql-server/root_password_again password pass'
sudo apt-get -y install mariadb-server mytop