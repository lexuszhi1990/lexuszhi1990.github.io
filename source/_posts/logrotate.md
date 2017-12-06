---
title: logrotate
date: 2014-06-25 11:07:13 +0800
comments: true
layout: post
category: dev
tags: [dev, logrotate]
---

### Create new rotate config file for application log

<!-- more -->

`$ sudo vim /etc/logrotate.d/example_application_log`

Type following contents, and save

```
/var/www/tidehunter/shared/log/*.log {
  daily
  missingok
  rotate 7
  compress
  delaycompress
  notifempty
  create 664 deploy deploy
  # copytruncate
}

```

其中 daily 表示每天整理，也可以改成 weekly 或 monthly
missingok 表示如果找不到 log 檔也沒關係
rotate 7 表示保留七份
compress 表示壓縮起來，預設用 gzip
delaycompress 表示延後壓縮直到下一次 rotate
notifempty 表示如果 log 檔是空的，就不 rotate
copytruncate 先複製 log 檔的內容後，在清空的作法，因為有些程式一定 log 在本來的檔名，例如 rails。另一種方法是 create。

### Create new rotate config file for server log:

```
$ sudo vim /etc/logrotate.d/nginx-log-for-example

Type following contents, and save.
/var/www/example/logs/*.log {

  daily

  missingok

  rotate 30

  notifempty

  create 664 root root

  sharedscripts

  postrotate

  # /opt/nginx/conf/nginx.conf
  # pid /var/run/nginx.pid;

  [ ! -f /var/run/nginx.pid ] || kill -USR1 `cat /var/run/nginx.pid`

  endscript

}
```

references
----------
- [syslog](http://linux.vbird.org/linux_basic/0570syslog.php)
- [ogrotate 定期整理 Rails Log](http://ihower.tw/blog/archives/3565)
