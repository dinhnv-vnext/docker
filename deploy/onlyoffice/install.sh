yum -y install initscripts
yum -y install sudo
curl -sL https://rpm.nodesource.com/setup_8.x | bash -
yum install -y nginx
yum install -y epel-release
yum install -y postgresql postgresql-server
service postgresql initdb
chkconfig postgresql on
\cp  pg_hba.conf /var/lib/pgsql/data/pg_hba.conf
service postgresql restart
cd /tmp
sudo -u postgres psql -c "CREATE DATABASE onlyoffice;"
sudo -u postgres psql -c "CREATE USER onlyoffice WITH password 'onlyoffice';"
sudo -u postgres psql -c "GRANT ALL privileges ON DATABASE onlyoffice TO onlyoffice;"
yum install -y redis
service redis start
systemctl enable redis
yum install -y rabbitmq-server
service rabbitmq-server start
systemctl enable rabbitmq-server
rabbitmqctl add_user onlyoffice onlyoffice123
rabbitmqctl set_user_tags onlyoffice administrator
rabbitmqctl set_permissions -p / onlyoffice ".*" ".*" ".*"
yum install -y http://download.onlyoffice.com/repo/centos/main/noarch/onlyoffice-repo.noarch.rpm
yum install -y onlyoffice-documentserver
rm -f /etc/onlyoffice/documentserver/local.json
service supervisord start
systemctl enable supervisord
rm -f /etc/nginx/nginx.conf
cp /opt/qadoc-onlyoffice/nginx.conf /etc/nginx/nginx.conf
service nginx start
systemctl enable nginx
service supervisord start
systemctl enable supervisord
bash /opt/qadoc-onlyoffice/doc-configure.sh
rm -f /etc/onlyoffice/documentserver/nginx/onlyoffice-documentserver.conf
cp /opt/qadoc-onlyoffice/nginx_onlyoffice.conf /etc/onlyoffice/documentserver/nginx/onlyoffice-documentserver.conf
service nginx restart