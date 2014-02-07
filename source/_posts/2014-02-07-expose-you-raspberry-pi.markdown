---
layout: post
title: "expose you rasbarry pi"
date: 2014-02-07 21:38:24 +0800
comments: true
categories: [tech, raspberry pi]
---

### use VPS and ssh

first, make sure there is a http server running on your rasbarry.
e.g. it runs on 3000 port.
```
$ curl http://127.0.0.1:3000
#=> here is David's rasbarry pi. powered by Nodejs.
```

then make sure your raspi has ssh key, and copy it to VPS server.

```
# user@host is your vps
ssh-copy-id user@host
```

second, binding the remote port forwarding to local port.
```
ssh -f -N -R 12345:127.0.0.1:3000 user@host
```
then, ssh to the vps server, and check out it.
e.g.

```
$ curl http://127.0.0.1:12345
#=> here is David's rasbarry pi. powered by Nodejs.
```

last, use nginx server to power it.
``` bash
# raspi server.
# /opt/nginx/conf/sites-enabled/rasberry-pi.conf
server {
  listen       80;
  server_name  rpi.lingzhi.me;
  location / {
    proxy_pass  http://127.0.0.1:12345;
    proxy_set_header   Host             $host:80;
    proxy_set_header   X-Real-IP        $remote_addr;
    proxy_set_header   X-Forwarded-For  $proxy_add_x_forwarded_for;
    proxy_set_header Via    "nginx";
  }
}
```

fix the GatewayPorts
```
# http://unixhelp.ed.ac.uk/CGI/man-cgi
# set GatewayPorts
# /etc/sshd_config

GatewayPorts clientspecified

```

then `sudo service ssh restart` and reload the nginx server, it will run successfully:
```
$ curl rpi.lingzhi.me
#=> here is David's rasbarry pi. powered by Nodejs.
```

### use [ngrok](https://github.com/inconshreveable/ngrok) to create a secure tunnel between from a public endpoint to a locally running web servic

references
----------
- [sshd_config](http://unixhelp.ed.ac.uk/CGI/man-cgi?sshd_config+5)
- [Using a VPS and SSH to expose your local machine's ports](http://bafford.us/2011/08/31/67745483-using-a-vps-and-ssh-to-expose-your-local-mach/)
- [Reverse SSH tunneling: easier than port forwarding!](http://bbrinck.com/post/2318562750/reverse-ssh-tunneling-easier-than-port-forwarding)
- [ssh+nginx反向代理访问内网Web Service](http://logit.me/blog/2013/05/31/reverse-proxy/)
