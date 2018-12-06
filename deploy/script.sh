#!/bin/bash
source ./config.env

init() {
  if [ -f ~/.ssh/id_rsa.pub ]
  then
    echo "Skip generator ssh key."
  else
    ssh-keygen -b 4096
  fi

  # add key to server
  echo "Add ssh key for QADOC-APP server: "
  ssh-copy-id $USER_LOGIN@$APP_HOST
  echo "Add ssh key for QADOC-ES server: "
  ssh-copy-id $USER_LOGIN@$ES_HOST
  echo "Add ssh key for QADOC-ONLYOFFICE server: "
  ssh-copy-id $USER_LOGIN@$ONLYOFFICE_HOST

  # init env for docker
  
  echo "WEB_URL=$APP_URL" > ./app/conf.env
  echo "ES_DNS=$ES_URL" >> ./app/conf.env
  echo "ONLYOFFICE_URL=$ONLYOFFICE_URL" >> ./app/conf.env

  #install docker on server
  ssh $USER_LOGIN@$APP_HOST "bash -s" << EOF
    yum install -y docker;
    systemctl start docker;
    systemctl enable docker;
    ln -s /usr/libexec/docker/docker-runc-current /usr/bin/docker-runc;
    ln -s /usr/libexec/docker/docker-proxy-current /usr/bin/docker-proxy
EOF
  ssh $USER_LOGIN@$ES_HOST "bash -s" << EOF
    yum install -y docker;
    systemctl start docker;
    systemctl enable docker;
    ln -s /usr/libexec/docker/docker-runc-current /usr/bin/docker-runc;
    ln -s /usr/libexec/docker/docker-proxy-current /usr/bin/docker-proxy;
    rm -rf /opt/elasticsearch/data/*;
    mkdir -p /opt/elasticsearch/data;
    chmod 777 /opt/elasticsearch/data
EOF
  docker login --username=$DOCKER_REPO_USER --password=$DOCKER_REPO_PASS
  build_es
  build_db
  build_app
  build_onlyoffice
  ssh $USER_LOGIN@$APP_HOST "bash -s" << EOF
    docker exec qadoc-app bash -c "/bin/sh /tmp/initialize.sh"
EOF
}

build_db() {
  scp ./app/mysql.env  $USER_LOGIN@$APP_HOST:/opt/qa-app/mysql.env
  ssh $USER_LOGIN@$APP_HOST "bash -s" << EOF
    cd /opt/qa-app/;
    docker rm -f qadoc-db;
    docker run -dit --name=qadoc-db \
    --restart always \
    --env-file ./mysql.env  \
    -v /var/lib/mysql:/var/lib/mysql \
    mysql:8.0.3;
EOF
}

build_app() {
  #build docker images
  cd ..
  docker build -t $DOCKER_REPO_USER/qadocs-app:latest -f ./deploy/app/Dockerfile .
  docker push $DOCKER_REPO_USER/qadocs-app

  # run on remote server
  ssh  $USER_LOGIN@$APP_HOST "mkdir -p /opt/qa-app/"
  cd deploy;
  scp ./app/app.env  $USER_LOGIN@$APP_HOST:/opt/qa-app/app.env
  scp ./app/conf.env  $USER_LOGIN@$APP_HOST:/opt/qa-app/conf.env
  scp ./app/sql/initdb.sql  $USER_LOGIN@$APP_HOST:/opt/qa-app/initdb.sql
  scp -r ./ssl-cert $USER_LOGIN@$ONLYOFFICE_HOST:/opt/qa-app/ssl-cert
  ssh $USER_LOGIN@$APP_HOST "bash -s" << EOF
    docker pull $DOCKER_REPO_USER/qadocs-app;
    cd /opt/qa-app/;
    docker rm -f qadoc-app;
    docker run -dit --name=qadoc-app \
      --restart always \
      -p 80:80 \
      -p 443:443 \
      --env-file ./app.env  \
      --env-file ./conf.env  \
      -v /opt/data:/owncloud/data \
      --link qadoc-db:mysql \
      $DOCKER_REPO_USER/qadocs-app;
EOF
}

build_es() {
  ssh  $USER_LOGIN@$ES_HOST "mkdir -p /opt/qa-es/" 
  scp ./elasticsearch/Dockerfile  $USER_LOGIN@$ES_HOST:/opt/qa-es/Dockerfile
  ssh $USER_LOGIN@$ES_HOST "bash -s" << EOF
   sysctl -w vm.max_map_count=262144;
   cd /opt/qa-es/;
   docker build -t qadoc-elasticsearch:latest .;
   docker rm -f qadoc-search;
   docker run -dit --name=qadoc-search --restart always -p 9200:9200  -v /opt/elasticsearch/data:/usr/share/elasticsearch/data qadoc-elasticsearch;
EOF
}

build_onlyoffice() {
  ssh  $USER_LOGIN@$ONLYOFFICE_HOST "rm -rf /opt/qadoc-onlyoffice/*" 
  scp -r ./onlyoffice/* $USER_LOGIN@$ONLYOFFICE_HOST:/opt/qadoc-onlyoffice
  scp -r ./ssl-cert $USER_LOGIN@$ONLYOFFICE_HOST:/opt/qadoc-onlyoffice/ssl-cert

  ssh $USER_LOGIN@$ONLYOFFICE_HOST "bash -s" << EOF
    cd /opt/qadoc-onlyoffice;
    bash install.sh
EOF
}

case "$1" in
  init)
      init
      ;;
  deploy_app)
		build_app
		;;
  *)
      echo $"Usage: $0 {init|deploy|help}"
      exit 1
esac
