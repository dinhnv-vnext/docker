#!/bin/sh
SQLFILE=/tmp/initdb.sql

echo ">> Create data directory"
rm -rf /owncloud/data/*
mkdir -p /owncloud/data
mkdir -p /owncloud/data/avatars/21/23/2f297a57a5a743894a0e4a801fc3
chown -R www-data:www-data /owncloud/data
cd /owncloud/data
touch .ocdata
chmod -R 777 /var/www/owncloud/config
chown www-data:www-data /var/www/owncloud/config/config.php

echo ">> Init database $DBNAME"
mysql -u $MYSQL_USER  -h $DB_DNS $MYSQL_DATABASE --default-character-set=utf8 < $SQLFILE
mysql -u $MYSQL_USER  -h $DB_DNS $MYSQL_DATABASE -e "INSERT INTO oc_appconfig VALUES ('onlyoffice', 'DocumentServerUrl', '$ONLYOFFICE_URL') ON DUPLICATE KEY UPDATE configvalue = '$ONLYOFFICE_URL'"