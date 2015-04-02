---
layout: post
title: "advanced-html-css-cn"
date: 2014-06-25 11:17:33 +0800
comments: true
categories: [tech, html, css]
published: false
---

[英文原版](http://learn.shayhowe.com/advanced-html-css/performance-organization/)

## LESSON 1
## Performance & Organization

代码的组织和结构不仅会对开发速度有很大的影响，而且还会影响html页面的加载速度。两者对开发者和用户都有相当大的影响。花点时间去设计正确的代码库(code base)结构，并思考如何让不同的部件协同工作，能加速开发工作，并有利于一个更好的整体体验。

另外，做一些小的措施来改进网页的表现能收到额外的效果。[Website performance](http://stevesouders.com/hpws/rules.php) 极大的遵循 80/20 原则，20% 的改进会对网站大约有80%的加速。

### Strategy & Structure

第一部分是提高一个网站的表现和组织主要取决于有一个好的策略和结构去开发整个代码。特别的，构建一个合理的目录结构，轮廓清晰的设计模式，和代码复用。

#### Style Architecture

如何确切的组织代码风格归结为个人喜好和这个网站的特性。但是一般来说，还有有一些最佳实践去遵循。一个习惯就是根据意图去分离文件，包括创建新的目录为公共的样式，用户接口组件，和业务逻辑模块

```
# Base
  – normalize.css
  – layout.css
  – typography.css
# Components
  – alerts.css
  – buttons.css
  – forms.css
  – list.css
  – nav.css
  – tables.css
# Modules
  – aside.css
  – footer.css
  – header.css
```

上述描述的体系结构包括三个目录，都是不同群的样式。目标是开始以一个系统思考网站而不是单独的页面，代码结构也应该反映这个意图。值得注意的是并没有任何页面特别的样式在这里。

`base`目录包换一些公用的样式和一些用于整个网站的变量，布局，字体风格等。`compenents` 目录包括一些特别指定的被用户接口元素，这些都被分解成了不同的文件比如`alerts` 和 `buttons`。 最后 `modules` 目录包括了一个页面不同的部分的样式，这些都取决于业务逻辑。

组件的样式是纯粹由接口驱动，和业务逻辑没有任何关系。模块包含整个业务逻辑的样式。
