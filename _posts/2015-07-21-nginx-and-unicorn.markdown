---
layout: post
title: nginx and unicorn
date: 2015-07-21 12:14
categories: [tech, nginx, unicorn]
---

### nginx with unicorn

app_server.conf

```
upstream eio_app_server {
  # server unix:/tmp/unicorn_eio.sock fail_timeout=0 weight=5;
  server localhost:9000 fail_timeout=0  weight=5;;
}

server {
  listen   80;
  charset  utf-8;
  server_name  eio.local;

  keepalive_timeout 5;

  root        /Users/david/bs_repos/eio/public;
  access_log  /Users/david/bs_repos/eio/log/nginx_access.log;
  error_log   /Users/david/bs_repos/eio/log/nginx_error.log;
  rewrite_log on;

  location ~* ^/(images|javascripts|stylesheets|img)/  {
    access_log    off;
    log_not_found off;
    expires       max;
    break;
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
      proxy_pass http://eio_app_server;
      break;
    }
  }
}
```

nginx.conf

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

start rails app
```
unicorn_rails -c /your-app-dir/unicorn/development.rb -E development -D
```
