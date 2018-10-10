# erp-api

## You should learn about
- [Docker](https://www.docker.com/what-docker)
- [Owncloud](https://doc.owncloud.org/server/10.0/developer_manual/app/)
- MySQL


## How to develop in local env

### install
[Docker](https://docs.docker.com/engine/installation) : v18.03.1-ce-mac65


## Create Local Development-Environment
### Clone Repository
```
$ git clone https://gitlab.gnext.asia/biznext_demo/source.git
```

### Create and start containers

```
$ cd docker
$ docker-compose up -d
```

### Set /etc/hosts to
```
$ vim /etc/hosts
127.0.0.1 qadocs.online
```

You can access <http://qadocs.online> , but response 500 error.
`don't worry`
### Initialize project

To initialize project :
```
$ docker-compose exec php-fpm bash -c "cd php-ci/bin && ./initialize.sh"
```
Check your local servers.
```
$ http://qadocs.online/
Account: admin/3Ptz<y

```

### `We are done!`

### Work with docker day by day
`This section for developer only.`
1. On terminal on your pc Then cd to api dir
``` docker-compose up -d ```
2. Code on your host pc
  - Git commit from here

## Run core command

### To update composer.lock

### To watch nginx logfiles

```
$ docker-compose exec webserver sh -c "tail -fn100 /var/log/nginx/application.access.log"
$ docker-compose exec webserver sh -c "tail -fn100 /var/log/nginx/application.error.log"
```  
### To connect mysql

```
$ docker-compose exec mysql sh -c "mysql -uroot -proot -Downcloud"
```

## Other docs
......