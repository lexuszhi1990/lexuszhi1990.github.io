---
layout: post
title: "node setup on Ubuntu 12.04"
date: 2014-04-28 09:42:00 +0800
comments: true
categories: true
published: false
---

env: ubuntu 12.04

```
# after install nodejs
sudo apt-get install nodejs

node -v # http://stackoverflow.com/questions/14914715/express-js-no-such-file-or-directory
-bash: /usr/sbin/node: No such file or directory

# solution
bash -r
```

<!-- more -->

### install npm

```
sudo apt-get install npm
```

### socket.io install

```
npm install socket.io

[office website](https://www.npmjs.org/package/socket.io)

# error:
npm http GET https://registry.npmjs.org/socket.io

npm ERR! Error: failed to fetch from registry: socket.io

# solution http://stackoverflow.com/questions/12913141/installing-from-npm-fails
npm config set registry http://registry.npmjs.org/
```
