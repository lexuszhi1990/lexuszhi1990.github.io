---
title: Responsive Web design
categories:
  - dev
tags:
  - frontend
  - resposive
  - web
comments: true
toc: true
date: 2014-02-07 15:55:23
---


### 定义
自适应网页设计是一种网页设计的技术做法，该设计可使网站在多种浏览设备上阅读和导航，同时减少缩放、平移和滚动。

<!-- more -->

### 优点
一个Web页面能适应各种显屏；较大的缩短了开发者开发网站的周期；具有良好的SEO功能，易于google搜索；给用户更好的体验。

### 媒体查询支持和功能
width、height、device-width、device-height、aspect-ratio和orientation 都是很有用的。width和height指浏览器视区的尺寸，可通过`$(window).width()`和`$(window).height()`取得，而device-width和device-height指显示器的尺寸。

`<meta name="viewport" content="width=device-width, initial-scale=1" />`

viewport是网页默认的宽度和高度，上面这行代码的意思是，网页宽度默认等于屏幕宽度（width=device-width），原始缩放比例（initial-scale=1）为1.0，即网页初始大小占屏幕面积的100%。

所有主流浏览器都支持这个设置，包括IE9。对于那些老式浏览器（主要是IE6、7、8），需要使用css3-mediaqueries.js。
```html
　<!--[if lt IE 9]>
　　　　<script src="http://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
　　<![endif]-->
```

### 如何编写媒体查询
CSS3的Media Queries可以查询设备的屏幕尺寸颜色等信息，我们就可以根据不同的设备来写CSS，让网页在不同设备上有更好的用户体验。
Media的常用类型:

|类型 |          解释|
|:-----:|--------------|
|all |         所有设备|
|braille |       盲文|
|embossed |      盲文打印|
|handheld |      手持设备|
|print |       文档打印或打印预览模式|
|projection |    项目演示，比如幻灯|
|screen |        彩色电脑屏幕|
|speech |        演讲|
|tty |         固定字母间距的网格的媒体，比如电传打字机|
|tv |          电视|

常用的Media Features 有 `width` `height` `device-width` `device-height` `orientation` `aspect-ratio`等。
下面简单介绍一下基本用法：

- `min-width` `max-width` 适应特定屏幕宽度

```
@media screen and (min-width:768px) and (max-width:1024px){
  body{padding:1em;}
}
```

device-aspect-ratio 特定屏幕长宽比例
```
/* for 4:3 screen */
@media only screen and (device-aspect-ratio:4/3){
    body{  }
}

/* for 16:9 and 16:10 screen */
@media only screen and (device-aspect-ratio:16/9) and (device-aspect-ratio:16/10){
    body{  }
}
```

- 选择性加载CSS，即自动探测屏幕宽度，然后加载相应的CSS文件。

    <link rel="stylesheet" type="text/css" media="screen and (min-width: 400px) and (max-device-width: 600px)" href="smallScreen.css" />

如果屏幕宽度在400像素到600像素之间，则加载smallScreen.css文件。
除了用html标签加载CSS文件，还可以在现有CSS文件中加载。
`@import url("tinyScreen.css") screen and (max-device-width: 400px);`

### 常用技巧###
- 使用相对字体大小
px像素（Pixel），相对长度单位。像素px是相对于显示器屏幕分辨率而言的。
em是相对长度单位，相对于当前对象内文本的字体尺寸。如当前对行内文本的字体尺寸未被人为设置，则相对于浏览器的默认字体尺寸。
*em*实际上是一个垂直测量,一个em等于任何字体中的字母所需要的垂直空间，而和它所占据的水平空间没有任何的关系，
任意浏览器的默认字体高都是16px。所有未经调整的浏览器都符合:1em=16px。
因此用px来定义字体，就无法用浏览器字体放大的功能。
e.g.
```
　　small {
　　　　font-size: 0.875em;
　　}
```
small元素的大小是默认大小的0.875倍，即14像素（14/16=0.875）。

- 不使用绝对宽度
由于网页会根据屏幕宽度调整布局，所以不能使用绝对宽度的布局，也不能使用具有绝对宽度的元素。这一条非常重要。
具体说，CSS代码不能指定像素宽度：

    width:xxx px;

只能指定百分比宽度：

    width: xx%;

或者

    width:auto;

- 图片的自适应（fluid image）
除了布局和文本，"自适应网页设计"还必须实现图片的自动缩放。这只要如下CSS代码：

    img { max-width: 100%;}

这行代码对于大多数嵌入网页的视频也有效，所以可以写成：　　

    img, object { max-width: 100%;}

老版本的IE不支持max-width，所以只好写成：

    img { width: 100%; }

此外，windows平台缩放图片时，可能出现图像失真现象。这时，可以尝试使用IE的专有命令：

    img { -ms-interpolation-mode: bicubic; }

#### Switching the order of block elements with CSS
Flexbox is the answer - particularly because you only need to support a single modern browser: Mobile Safari.

```css
#blockContainer {
    display: -webkit-box;
    display: -moz-box;
    display: box;

    -webkit-box-orient: vertical;
    -moz-box-orient: vertical;
    box-orient: vertical;
}
#blockA {
    -webkit-box-ordinal-group: 2;
    -moz-box-ordinal-group: 2;
    box-ordinal-group: 2;
}
#blockB {
    -webkit-box-ordinal-group: 3;
    -moz-box-ordinal-group: 3;
    box-ordinal-group: 3;
}
```
```html
<div id="blockContainer">
    <div id="blockA">Block A</div>
    <div id="blockB">Block B</div>
    <div id="blockC">Block C</div>
</div>
```

another way is to use table element

```html
<div class="container">
    <div class="block-1">1st block</div>
    <div class="block-2">2nd block</div>
    <div class="block-3">3rd block</div>
</div>
<style>
    .container { display: table; width: 100%; }
    .block-1 { display: table-footer-group; } /* Will display at the bottom. */
    .block-2 { display: table-row-group;    } /* Will display in the middle. */
    .block-3 { display: table-header-group; } /* Will display at the top. */
</style>
```

references
-----------------
- [MediaQueries](http://www.w3.org/TR/css3-mediaqueries)
- [RWD-wiki](http://zh.wikipedia.org/wiki/%E5%93%8D%E5%BA%94%E5%BC%8F%E7%BD%91%E9%A1%B5%E8%AE%BE%E8%AE%A1)
- [Switching the order of block elements with CSS](http://stackoverflow.com/questions/7425665/switching-the-order-of-block-elements-with-css)
- [Blog about RWD](http://www.ruanyifeng.com/blog/2012/05/responsive_web_design.html)
- [frontend](http://imshanks.com/css3-media-queries/)
- [Some Useful Examples](http://www.w3cplus.com/css3/responsive-web-design.html)
- [*em* in css](http://www.w3cplus.com/css/px-to-em)
- [*rem* with font size](http://ued.taobao.com/blog/2013/05/rem-font-size/)
- [dimenssions](https://chrome.google.com/webstore/detail/dimensions/hdmihohhdcbejdkidbfijmfehjbnmifk/)
