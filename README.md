### Dockerによるインフラ環境を構築する。インフラ構造はWWWサーバ、DBサーバを含む

##### DB構築
DockerfileからDBサーバイメージを作る
```
$ cd ~/project/docker/mysql
$ docker build --no-cache=true --rm -t mysql5.6 .
```

DBイメージが作成されているか確認
```
$ docker images
REPOSITORY                    TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
mysql5.6                      latest              4cb799ad30cf        22 seconds ago        324.2 MB
```

DBイメージからコンテナを作る
```
$ docker run -it -d --name mysql5.6 -p 3306:3306 -e MYSQL_USER=thang -e MYSQL_PASSWORD=thang -e MYSQL_ROOT_PASSWORD=thang mysql5.6
```

DBコンテンナが作成されているか確認
```
$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
bf50eb6f9c8e        mysql5.6     "/entrypoint.sh mysql"   11 minutes ago      Up 11 minutes       0.0.0.0:3306->3306/tcp   mysql5.6
```

DBへアクセスできたか確認。サーバへアクセスするには、`exec`コマンドを使う
```
$ docker exec -it bf50eb6f9c8e bash
root@bf50eb6f9c8e:/# mysql -u thang -pthang
Warning: Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 6
Server version: 5.6.29 MySQL Community Server (GPL)

Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

##### WWW構築

DockerfileからWWWサーバイメージを作る。イメージが存在したら削除して再作成する
```
$ cd ~/project/docker/nginx
$ docker build --no-cache=true --rm -t nginx .
```

WWWイメージが作成されているか確認
```
$ docker images
REPOSITORY                    TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
nginx                         latest              24c408092536        10 seconds ago        527.2 MB
mysql5.6                      latest              4cb799ad30cf        30 minutes ago        324.2 MB
```

WWWイメージからコンテナを作り、DBサーバと接するように`--link`を付ける。
```
$ docker run -it -d --name nginx -p 8080:80 --link mysql5.6:db nginx 
```
dbはアリアス。コンテナ作成後に、`env`コマンドを実行すると、dbというvariableは入っている。

WWWコンテンナが作成されているか確認
```
$ docker ps
CONTAINER ID        IMAGE           COMMAND                CREATED             STATUS              PORTS                       NAMES
67f574b36f80        nginx           "/bin/bash"           12 minutes ago      Up 12 minutes    22/tcp, 0.0.0.0:8080->80/tcp    nginx
bf50eb6f9c8e        mysql5.6     "/entrypoint.sh mysql"   28 minutes ago      Up 28 minutes       0.0.0.0:3306->3306/tcp      mysql5.6
```

ウェブサーバへアクセスしたか確認
```
$ docker exec -it 67f574b36f80 bash
[root@67f574b36f80 /]# mysql -h db -u thang -pthang
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 7
Server version: 5.6.29 MySQL Community Server (GPL)

Copyright (c) 2000, 2013, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

`env`で確認する
```
[root@67f574b36f80 /]# env | grep -i db
DB_ENV_MYSQL_USER=thang
DB_ENV_MYSQL_PASSWORD=thang
DB_NAME=/mad_morse/db
DB_PORT=tcp://172.17.0.9:3306
DB_PORT_3306_TCP_PORT=3306
DB_PORT_3306_TCP_PROTO=tcp
DB_ENV_MYSQL_ROOT_PASSWORD=thang
DB_PORT_3306_TCP_ADDR=172.17.0.9
DB_PORT_3306_TCP=tcp://172.17.0.9:3306
DB_ENV_MYSQL_VERSION=5.6.29-1debian8
DB_ENV_MYSQL_MAJOR=5.6
```


