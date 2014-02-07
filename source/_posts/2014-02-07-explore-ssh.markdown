---
layout: post
title: "explore ssh"
date: 2014-02-07 21:33:53 +0800
comments: true
categories: [tech, ssh]
---

### ssh config

```sh ~/.ssh/config
Host your-host.com
  User David
  Port 443
  Hostname ssh.github.com
  identityfile ~/.ssh/id_rsa
```

### edit ssh port
vi /etc/ssh/sshd_config
```
Port 8888               //以前这个前面是有 # 号的，而且默认是 22 ，修改一下就ok了
```

add ssh port
```
sudo /usr/sbin/sshd -p 8888
netstat -an

Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
  ....
  tcp        0      0 0.0.0.0:8888            0.0.0.0:*               LISTEN
  ....
```

restart ssh service
```
sudo service ssh restart
```

### ssh options

  N参数，表示只连接远程主机，不打开远程shell；T参数，表示不为这个连接分配TTY。这个两个参数可以放在一起用，代表这个SSH连接只用来传数据，不执行远程操作。

  f参数，表示SSH连接成功后，转入后台运行。要关闭这个后台连接，就只有用kill命令去杀掉进程。

```
　$ ssh -R 2121:host2:21 host1
```

  R参数也是接受三个值，分别是"远程主机端口:目标主机:目标主机端口"。这条命令的意思，就是让host1监听它自己的2121端口，然后将所有数据经由host3，转发到host2的21端口。由于对于host3来说，host1是远程主机，所以这种情况就被称为"远程端口绑定"。


references
----------
- [iptables](http://wiki.ubuntu.org.cn/IptablesHowTo)
- [netstat](http://www.cnblogs.com/ggjucheng/archive/2012/01/08/2316661.html)
- [ssh-remote-login](http://www.ruanyifeng.com/blog/2011/12/ssh_remote_login.html)
- [ssh-port-forwarding](http://www.ruanyifeng.com/blog/2011/12/ssh_port_forwarding.html)
