---
layout: post
title: "apache access and user agent"
date: 2014-02-08 21:03:11 +0800
comments: true
categories: [tech, apache, rails]
---

### config access for for apache 2.2
if we want to deny the user which ip is 183.60.244.33, and use the agent of Python-urllib, wo can config like this

<!-- more -->

```
<Directory />
  SetEnvIf User-Agent Python-urllib GoAway=1
  Order allow,deny
  Allow from all
  Deny from 183.60.244.33
  Deny from env=GoAway
</Directory>
```

### User Agent
User Agent字段 这个字段是用来表示客户端的设备信息。服务器有时会根据这个字段，针对不同设备，返回不同格式的网页，比如手机版和桌面版。 iPhone4的User Agent是
```
Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7
```

其他的User Agent还有
```
Python-urllib/2.7
Opera/9.80 (X11; U; Linux i686; en-US; rv:1.9.2.3) Presto/2.2.15 Version/10.10
Mozilla/4.0 (compatib1e; MSIE 6.1; Windows NT)
Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:0.9.2) Gecko/20020508 Netscape6/6.1
```

curl可以这样模拟user agent：
```
curl --user-agent "[User Agent]" [URL]

curl --user-agent Python-urllib/2.7 http://google.com/
```

references
----------
- [ruanyifeng-curl](http://www.ruanyifeng.com/blog/2011/09/curl.html)
- [rurl-docs](http://curl.haxx.se/docs/manpage.html)
- [apache2.2-access](http://httpd.apache.org/docs/2.2/howto/access.html)
- [apache2.4-access](http://httpd.apache.org/docs/current/howto/access.html)
