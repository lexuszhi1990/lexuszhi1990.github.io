---
layout: post
title: apache config in osx
date: 2015-04-03 16:41:42 +0800
categories: [dev, apache]
---

# install apache

`brew install apache`,

### set up mysql in osx

``` sh
To connect:
    mysql -uroot

To have launchd start mysql at login:
    ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
Then to load mysql now:
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist
Or, if you don't want/need launchctl, you can just run:
    mysql.server start
```

### creae user in mysql

```
CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON * . * TO 'newuser'@'localhost';
FLUSH PRIVILEGES;
```

### install ngnix

`brew install nginx`,

```
Docroot is: /usr/local/var/www

The default port has been set in /usr/local/etc/nginx/nginx.conf to 8080 so that
nginx can run without sudo.

To have launchd start nginx at login:
    ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents
Then to load nginx now:
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
Or, if you don't want/need launchctl, you can just run:
    nginx
```



```
 $ brew install nginx --with-passenger

To activate Phusion Passenger for Apache, create /etc/apache2/other/passenger.conf:
  LoadModule passenger_module /usr/local/opt/passenger/libexec/buildout/apache2/mod_passenger.so
  PassengerRoot /usr/local/opt/passenger/libexec/lib/phusion_passenger/locations.ini
  PassengerDefaultRuby /usr/bin/ruby

Docroot is: /usr/local/var/www

The default port has been set in /usr/local/etc/nginx/nginx.conf to 8080 so that
nginx can run without sudo.

To activate Phusion Passenger, add this to /usr/local/etc/nginx/nginx.conf, inside the 'http' context:
  passenger_root /usr/local/opt/passenger/libexec/lib/phusion_passenger/locations.ini;
  passenger_ruby /usr/bin/ruby;

To have launchd start nginx at login:
    ln -sfv /usr/local/opt/nginx/*.plist ~/Library/LaunchAgents
Then to load nginx now:
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.nginx.plist
Or, if you don't want/need launchctl, you can just run:
    nginx
```


install passenger with nginx

`sudo passenger-install-nginx-module`


Now for your new entry to take effect, the DNS cache needs to be flushed.

```
dscacheutil -flushcache
```
