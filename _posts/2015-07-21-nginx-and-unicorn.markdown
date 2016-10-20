---
layout: post
title: nginx and unicorn and puma
date: 2015-07-21 12:14
categories: [dev, nginx, unicorn]
---

### app.conf for puma

```sh
upstream zhongyi_app {
  server unix:///your-project/shared/tmp/sockets/zhongyi.server.puma.sock;
}

server {
  listen   80;
  charset  utf-8;
  server_name  localhost;

  root        /your-project/current/public;
  access_log  /your-project/current/log/nginx_access.log;
  error_log   /your-project/current/log/nginx_error.log;
  rewrite_log on;

  # https://ruby-china.org/topics/19437
  # http://blog.csdn.net/netdxy/article/details/50670734
  location ~ ^/(assets)/  {
    root /your-project/current/public;
    gzip_static on; # to serve pre-gzipped version
    expires max;
    add_header Cache-Control public;
  }

  try_files $uri/index.html $uri @zhongyi_app;

  location @zhongyi_app {
    proxy_pass http://zhongyi_app;

    proxy_set_header Host               $host;
    proxy_set_header X-Forwarded-Host   $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Real-IP          $remote_addr;
    proxy_set_header X-Forward-For      $proxy_add_x_forwarded_for;
    proxy_buffering  on;
    proxy_redirect   off;
  }

  error_page 500 502 503 504 /500.html;
  client_max_body_size 10M;
  keepalive_timeout 10;
}
```


### app.conf for unicorn

```sh
upstream app_server {
  # server unix:/tmp/unicorn_eio.sock fail_timeout=0 weight=5;
  server localhost:9000 fail_timeout=0  weight=5;;
}

server {
  listen   80;
  charset  utf-8;
  server_name  eio.local;

  keepalive_timeout 5;

  root        /Users/your-project-repos/public;
  access_log  /Users/your-project-repos/log/nginx_access.log;
  error_log   /Users/your-project-repos/log/nginx_error.log;
  rewrite_log on;

  // https://ruby-china.org/topics/19437
  location ~ ^/(assets)/  {
    root /Users/your-project-repos/public;
    gzip_static on; # to serve pre-gzipped version
    expires max;
    add_header Cache-Control public;
  }

  location / {
    proxy_set_header Host               $host;
    proxy_set_header X-Forwarded-Host   $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Real-IP          $remote_addr;
    proxy_set_header X-Forward-For      $proxy_add_x_forwarded_for;
    proxy_buffering  on;
    proxy_redirect   off;

    if (!-f $request_filename) {
      proxy_pass http://app_server;
      break;
    }
  }

  error_page 500 502 503 504 /500.html;
  client_max_body_size 10M;
  keepalive_timeout 10;
}
```

### nginx.conf

```
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;
    keepalive_timeout  65;
    tcp_nopush off; # off may be better for *some* Comet/long-poll stuff
    tcp_nodelay on; # on may be better for some Comet/long-poll stuff
    gzip  on;
    # include sites
    include /usr/local/etc/nginx/sites-enabled/*;
}

```

### start rails app

```
unicorn_rails -c /your-app-dir/unicorn/development.rb -E development -D
```
