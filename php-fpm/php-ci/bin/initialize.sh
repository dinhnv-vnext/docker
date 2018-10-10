#!/bin/sh
SQLFILE=/var/www/sql/initdb.sql

echo ">> Create data directory"
rm -rf /owncloud/data
mkdir -p /owncloud/data
chown -R www-data:www-data /owncloud/data
cd /owncloud/data
touch .ocdata

echo ">> Init database $DBNAME"
mysql -u $MYSQL_USER  -h $DB_DNS $MYSQL_DATABASE --default-character-set=utf8 < $SQLFILE