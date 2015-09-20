---
layout: post
title: rails 项目经验小结
date: 2015-07-24 22:39
categories: [dev, ruby, rails]
publish: true
---

一晃断断续续在广州工作快两年了，因为要去深圳读书，一想平时给大家做的分享很少，所以在走之前也给大家做了一次内部的技术分享。主要包括的rails各个部分以及数据库，debug，alias，前端设计相关的。

[技术分享的slide: rails-dev-experices](http://www.slideshare.net/David_fu/rails-dev-experices)

## rack

Rack::Builder implements a small DSL to iteratively construct Rack applications

推荐[railsconf 上面的一个视频: from rails to the web server to the browser](http://confreaks.tv/videos/railsconf2013-from-rails-to-the-web-server-to-the-browser)

### rails controller

Request資訊收集包含有
  action_name
  cookies
  headers
  params
  request
  xml_http_request? 或 xhr?
  host_with_port
  remote_ip
  headers
  response
  session

  [rails guides about request](http://api.rubyonrails.org/classes/ActionDispatch/Request.html)

Render結果
  1. render(json/xml/html)
  2. redirect_to
  3. 数据流 send_data/send_file

Sessions处理

Cookies处理

Flash消息处理

[rails guides: action controller overview](http://guides.rubyonrails.org/action_controller_overview.html)

[ihower actioncontroller](https://ihower.tw/rails4/actioncontroller.html)

[rails 重构经验](http://yedingding.com/2013/03/04/steps-to-refactor-controller-and-models-in-rails-projects.html)

在这个的视频中，他就提到 controller 的代码最多10行，可能有点极端，但是还是很符合rails的风格的。
以为如果controller的代码过于冗余和复杂，项目的维护性和可读性都会大打折扣的。

1. Skinny Controller, Fat Model
2. Concern 其实也就是我们通常说的 Shared Mixin Module
  就是把 Controllers/Models 里面一些通用的应用逻辑抽象到一个 Module 里面做封装，我们约定叫它 Concern
3. Delegation Pattern
  [ruby forwardable](http://ruby-doc.org/stdlib-2.0.0/libdoc/forwardable/rdoc/Forwardable.html)
  [dive into forwardable](http://www.saturnflyer.com/blog/jim/2015/01/20/ruby-forwardable-deep-dive/)
4. Service and Presenter

### rails model

这个就没什么多说的，强烈推荐 **ruby 元编程** 这本书。则可以了解下面的知识，activespport，concern， ruby类重访， include/extend等等。

### asset precompile

推荐两篇文章

[一次搞懂asset precompile](http://gogojimmy.net/2012/07/03/understand-assets-pipline/)

[使用 Rails Asset Pipeline 配合 Nginx 的 gzip_static 优化 tips](https://ruby-china.org/topics/19437)

### javacript

[Secrets of the JavaScript Ninja](http://book.douban.com/subject/3176860/)

[Functional JavaScript](http://book.douban.com/subject/22733640/)

### debug

- log file
- pry

[slideshow：出了问题不要猜](https://speakerdeck.com/lidaobing/chu-liao-wen-ti-bu-yao-kao-cai)

[视频：出了问题不要猜](http://railscasts-china.com/episodes/do-not-guess-the-problem-lidaobing)

### effeciency

1. alias

- 最常用的命令. e.g. `alias rr="be rake routes`
- 将常用的几个命令捆绑成一个命令
  `alias 'one-task-ended'='git-master-update && git-delete-merged-branches && csd'`
- 为每个项目订制命令

  e.g.

  ```sh
  # my-project
  alias cd-my-project="cd ~/repos/my-project"
  alias my-project-server="rs -p 3200 -b 0.0.0.0"
  alias my-project-suspend="cat tmp/pids/server.pid | xargs -n 1 kill -9"
  ...
  ```

2. two screens也就是双屏幕操作

### 基本的设计概念

作为后端的开发者，也要有基本的设计概念和前端的常识，**写给大家看的设计书** 这本书则非常好的介绍了亲密性、对齐、重复和对比4 个基本原则，强烈推荐

http://book.douban.com/subject/3323633/

- 对齐
- 颜色
- 字体
- ...
