#!/bin/bash


yum install -y mariadb mariadb-server
/usr/bin/mysql_install_db --user=mysql
systemctl start mariadb
mysql -uroot -e "create database zabbix character set utf8 collate utf8_bin;"
mysql -uroot -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"
yum install -y http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
yum install -y zabbix-server-mysql zabbix-web-mysql
zcat /usr/share/doc/zabbix-server-mysql-*/create.sql.gz | mysql zabbix -uzabbix -pzabbix
sed -i '/DBHost=localhost/a DBHost=localhost' /etc/zabbix/zabbix_server.conf
sed -i '/DBPassword=/a DBPassword=zabbix' /etc/zabbix/zabbix_server.conf
sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone Europe\/Minsk/' /etc/httpd/conf.d/zabbix.conf
cp /vagrant/zabbix.conf.php /etc/zabbix/web/
sed -i '/ListenPort=/a ListenPort=10051' /etc/zabbix/zabbix_server.conf
sed -i '/StartTrappers=/a StartTrappers=1' /etc/zabbix/zabbix_server.conf
systemctl start httpd
systemctl start zabbix-server
yum install -y zabbix-agent
systemctl start zabbix-agent

## get TOKEN

#OUT=$(curl -i -X POST -H "Content-Type: application/json-rpc" -d '{"jsonrpc": "2.0", "method": "user.login", "params": {"user": "Admin", "password": "zabbix"}, "id": 1, "auth": null}' HTTP://192.168.56.10/zabbix/api_jsonrpc.php)

#TOKEN="$(echo $OUT | awk 'FNR == 1 {print$30}' | cut -c 27-60)"



## create template

#templamba=$(curl -i -X POST -H "Content-Type: application/json" -d '{"jsonrpc": "2.0", "method": "template.create", "params": {"host": "Test template", "groups": {"groupid": 1}}, "auth": '$TOKEN', "id": 1}' 192.168.56.10/zabbix/api_jsonrpc.php)

#echo $templamba

#templamba2="$(echo $templamba | awk 'FNR == 1 {print$30}' | cut -d '"' -f 10)"

#echo $templamba2

## create group CloudHosts

#mamba=$(curl -i -X POST -H "Content-Type: application/json" -d '{"jsonrpc": "2.0", "method": "hostgroup.get", "params": {"filter": {"name": "CloudHosts"}}, "auth": '$TOKEN', "id": 1}' 192.168.56.10/zabbix/api_jsonrpc.php)

#echo $mamba

#mamba2="$(echo $mamba | awk 'FNR == 1 {print$30}' | cut -c 27-28)"

#echo $mamba2

#mamba3=$([ $mamba2 != "[]" ] && echo "Existed" || curl -i -X POST -H "Content-Type: application/json" -d '{"jsonrpc": "2.0", "method": "hostgroup.create", "params": {"name": "CloudHosts"}, "auth": '$TOKEN', "id": 1}' 192.168.56.10/zabbix/api_jsonrpc.php)

#echo $mamba3

# GID

#mamba4="$(echo $mamba3 | awk 'FNR == 1 {print$30}' | cut -d '"' -f 10)"

#echo $mamba4

# create auto-reg

#curl -i -X POST -H "Content-Type: application/json" -d '{"jsonrpc": "2.0", "method": "action.create", "params": {"name": "Autoreg", "eventsource": 2, "status": 0, "operations": [{"operationtype": 2}, {"operationtype": 4, "opgroup": [{"groupid": "'"$mamba4"'"}]}, {"operationtype": 6, "optemplate": [{"templateid": "'"$templamba2"'"}]} ]}, "auth": '$TOKEN', "id": 1}' 192.168.56.10/zabbix/api_jsonrpc.php
