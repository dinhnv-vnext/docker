# Bizknowledge qadocs

## You should learn about
- [Docker](https://www.docker.com/what-docker)
- [Owncloud](https://doc.owncloud.org/server/10.0/developer_manual/app/)
- MySQL


## How to deploy from local env

### install
[Docker](https://docs.docker.com/engine/installation) : v18.03.1-ce-mac65


## Create Local Environment
### Clone Repository
```
$ git clone https://gitlab.gnext.asia/biznext_demo/source.git
```

### Create docker image and push to docker hub

```
$ cd deploy
```

### Enter your server information.
```
$ vim config.env
```

### Build docker end deploy to server
```
$ bash script.sh init
```
`Note 1: Only run once when the server initializes`

`Note 2: You must enter 3 ssh passwords for 3 servers`

Check your local servers.
```
$ https://base-app-ssh.bizknowledge-qadocs.com
Account: admin/3Ptz<y

```

### Update source code for qadoc-app
```
$ bash script.sh deploy_app
```

### `We are done!`
