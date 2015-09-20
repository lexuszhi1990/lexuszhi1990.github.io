---
layout: post
title: 前端开发人员需要了解的关于rails的知识点
date: 2015-09-20 14:08
categories: [dev, frontend, rails]
published: true
---

虽然rails开发者经常是全栈开发者，但术业有专攻，很多事需要和前端开发人员配合，而且如果纯后端人员去调很复杂的页面，相对来说，效率很低。由于纯前端开发人员专注力主要集中在html/css 以及 js 上面，所以在项目合作配合的时候双方会觉得比较吃力。在公司同事的建议下，我就列了一个list，可以说是一个roadmap，让他们能够简单的了解rails项目结构，并能够在rails项目里面做一些controller/view层的开发。

### Rails routes

- http 协议

 请求方法 GET、POST、HEAD、CONNECT、PUT、DELETE、TRACE

 具体的介绍：
 http://zsxxsz.iteye.com/blog/568250
 http://www.cnblogs.com/li0803/archive/2008/11/03/1324746.html

- Action Controller - 控制 HTTP 流程
  了解 restful 路由设计
 https://ihower.tw/rails4/actioncontroller.html


- 学习写 routes。
  从简单的put get delete post 等，到resources/member/collection
  https://ihower.tw/rails4/actioncontroller.html

- routes 相关的task commands

### Rails MVC

https://ihower.tw/rails4/actionview.html

- 具体的介绍 rails mvc框架结构。
- 能够简单的写controller 和 view。
- 了解render partical， 以及layouts。能够写出一个简单的规范的（包含 header, footer) 页面
- 了解 view 中的一些简单的helper方法。 https://ihower.tw/rails4/actionview-helpers.html

### Rails GEMS

- 如何添加简单的gems 到项目里面来。比如 bootstrap，jquery 插件。

### Assets 相关

https://ihower.tw/rails4/assets-pipeline.html

- 了解在view 中 rails 是如何载入 js/css 文件的。
- rails 里面图片的处理(sass image-url/image-path)
- assets precompile

能够做到在rails项目中添加图片 和 写js/css/scss。

[一次搞懂asset precompile](http://gogojimmy.net/2012/07/03/understand-assets-pipline/)

### 最终目标

- 对rails项目结构有个直观的了解
- 了解rails mvc框架
- 在对psd出html页面的过程中，能够更好的适应rails项目
- 了解assets precompile，并能够在rails项目中添加，删除css/js文件
- 了解erb/slim/haml等tamplate engine, 能够在rails项目对view做简要的修改
