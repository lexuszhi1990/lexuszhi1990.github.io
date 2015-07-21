[---
layout: post
title: add hstore extension to postgrel
date: 2015-07-21 11:23:23 +0800
category: tech
tags: [postgres, json
---

### TODO： add hstore extension to postgrel

http://stormatics.com/howto-handle-key-value-data-in-postgresql-the-hstore-contrib/
http://yousefourabi.com/blog/2014/03/rails-postgresql/
http://www.postgresql.org/docs/9.4/static/hstore.html
https://stelfox.net/blog/2014/05/pg-error-error-type-hstore-does-not-exist/
http://edgeguides.rubyonrails.org/active_record_postgresql.html#hstore

http://clarkdave.net/2012/09/postgresql-error-type-hstore-does-not-exist/
http://stackoverflow.com/questions/11584749/how-to-create-a-new-database-with-the-hstore-extension-already-installed

### 解决添加hstroe extension时候 权限问题。

```
 ** [out :: play.beansmile.com] PG::InsufficientPrivilege: ERROR:  permission denied to create extension "hstore"
 ** [out :: play.beansmile.com] HINT:  Must be superuser to create this extension.
```

解决办法，就是ssh到服务器，给这个user 添加权限

```
sudo -u postgres psql postgres;
ALTER USER mydb_user WITH SUPERUSER;
```

### 解决创建数据库时候 encode 问题。

当执行 `cap-s remote:rake db:create` 的时候，出现下面的问题，意思是(UTF8) 和 pg template的编码不兼容。

  * executing "cd /var/www/veda.beansmile.com/current && RAILS_ENV=staging bundle exec rake db:create"
    servers: ["play.beansmile.com"]
    [play.beansmile.com] executing command
 ** [out :: play.beansmile.com] PG::InvalidParameterValue: ERROR:  new encoding (UTF8) is incompatible with the encoding of the template database (SQL_ASCII)
 ** [out :: play.beansmile.com] HINT:  Use the same encoding as in the template database, or use template0 as template.
 ** [out :: play.beansmile.com] : CREATE DATABASE "veda_staging" ENCODING = 'utf8'

server上面用的 pg 版本是 psql (9.1.11, server 9.1.15)

server上面的database.yml 是这样的 ：

```
default: &default
  adapter: postgresql
  encoding: unicode
  # template: template0
  pool: 5

staging:
  <<: *default
  database: project_staging
```

根据stackoverflow [这篇文章](http://stackoverflow.com/questions/5821238/rake-dbcreate-encoding-error-with-postgresql), 总结了一下，有两种解决办法:

第一种直接粗暴：
在 `database.yml` 中直接加入 `template: template0`。

第二种则是修改 *template1* 的encode.

首先以super user登入 pg

```
so $sudo -u postgres psql

CREATE EXTENSION hstore;
```

然后具体执行如下

```
# First, we need to drop template1. Templates can’t be dropped, so we first modify it so t’s an ordinary database:

        UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';

# Now we can drop it:

        DROP DATABASE template1;

# Now its time to create database from template0, with a new default encoding:

        CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UTF-8';

# Now modify template1 so it’s actually a template:

        UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';

# Now switch to template1 and VACUUM FREEZE the template:

        \c template1 VACUUM FREEZE;
```
