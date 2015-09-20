---
layout: post
title: postgres basic usages
date: 2015-07-21 11:21:22 +0800
categories: [tech, postgres, usages]
---

### 启动数据库

*start when boot up* :

```sh
# 这里以你按照的实际目录文件为准
To have launchd start postgresql at login:
  ln -sfv /usr/local/opt/postgresql/*.plist ~/Library/LaunchAgents
Then to load postgresql now:
  launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
```

*start by hand* :

`pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start`

*restart* :

`brew services restart postgresql` or `pg_ctl -D /usr/local/var/postgres -l logfile start`

### 登录数据库

添加新用户和新数据库以后，就要以新用户的名义登录数据库，这时使用的是psql命令。

`psql -U dbuser -d exampledb -h 127.0.0.1 -p 5432`

上面命令的参数含义如下：-U指定用户，-d指定数据库，-h指定服务器，-p指定端口。
输入上面命令以后，系统会提示输入dbuser用户的密码。输入正确，就可以登录控制台了。

psql命令存在简写形式。如果当前Linux系统用户，同时也是PostgreSQL用户，则可以省略用户名（-U参数的部分）。

举例来说，如果操作系统用户名为david，PostgreSQL数据库存在同名用户david，pg数据库中有david创建的table：template0，可以直接使用下面的命令登录数据库，且不需要密码。

```
              Name               |  ***  | Access privileges
---------------------------------+  ***  +-------------------
 template0                       |  ***  | =c/david
```

`psql -d template0` 或者直接 `psql template0`

此时，如果PostgreSQL内部还存在与当前系统用户同名的数据库，则连数据库名都可以省略。

```
              Name               |  ***  | Access privileges
---------------------------------+  ***  +-------------------
 david                           |  ***  | =c/david

```

直接输入 `psql` 即可登入。

### 添加删除用户

psql以postgres用户登入，创建新的用户，

```
sudo -U postgres psql
```

```sh
# create a user named developer and password is `password`
postgres=# create user developer with superuser createdb encrypted password 'password';
# => CREATE ROLE

# select the roles
postgres=# select rolname from pg_roles;
=>  rolname
    ----------
    ...
    developer
    ...

# edit password
postgres=# alter user developer with encrypted password 'yourpassword';
=> ALTER ROLE

# drop user
postgres=# drop user developer;
=> DROP ROLE
```

### 添加删除database

#### drop database with sessions

http://blog.csdn.net/windone0109/article/details/8849291

`select * from pg_stat_activity where datname='your-database-name';`

kill -9 procpid对应的进程

### 控制台命令

| 命令  | 解释 |
| :------------- | :------------- |
|\h：| 查看SQL命令的解释，比如\h select。|
|\?：| 查看psql命令列表。|
|\l：| 列出所有数据库。|
|\c [database_name]：| 连接其他数据库。|
|\d：|列出当前数据库的所有表格。|
|\d [table_name]：| 列出某一张表格的结构。|
|\du：| 列出所有用户。|
|\e：| 打开文本编辑器。|
|\conninfo：|列出当前数据库和连接的信息。|


### references

- [getting started with postgresql](http://www.ruanyifeng.com/blog/2013/12/getting_started_with_postgresql.html)
