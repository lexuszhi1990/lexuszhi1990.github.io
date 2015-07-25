---
layout: post
title: "做一个用nodejs控制的小车"
date: 2014-06-03 10:02:07 +0800
comments: true
published: false
categories: [dev, raspi, node]
---


小车的模板
http://detail.tmall.com/item.htm?spm=a230r.1.14.1.X177j2&id=22045647259&ad_id=&am_id=&cm_id=140105335569ed55e27b&pm_id=

小车的控制模块
http://detail.tmall.com/item.htm?spm=a1z10.3.w4011-4089885456.179.azLW58&id=16511130359&rn=edae9d278ce8f80fabed5566d3d58f12
因为这个小车是4驱的，所以需要2个L298N模块。

现在有另外一种组件就是 四路直流电机驱动模块
http://item.taobao.com/item.htm?spm=a230r.1.14.132.MJmuA8&id=19107427509&_u=gh491pf90b8
或者是
http://item.taobao.com/item.htm?spm=a230r.1.14.47.MJmuA8&id=17114647163&_u=gh491pf3e9f

能不能帮我评估下这个模块， 这个模块的功能主要有：
可以直接驱动4路3-16V直流电机，并提供了5V输出接口（输入最低只要6V），就可以给5V单片机电路系统供电（低
纹波系数）,支持3.3V MCU ARM控制，可以方便的控制直流电机速度和方向，也可以控制2相步进电机，5线4相步进
电机。是4轮小车，智能小车必备利器

那是不是说，这个可以用输出的5V给树莓派进行供电了，但是树莓派用的是microUSB，这样有什么办法没有？

另外一个问题就是电源了，电源是不是用这个就可以了
http://item.taobao.com/item.htm?spm=a1z10.1.w1031-4299224422.4.2f6shR&id=19141929314
但是树莓派是mircoUSB的接口。如果不能用四路直流电机驱动模块供电，我的想法是用一个移动电源供电。
http://item.jd.com/1023954.html
这样树莓派和电机驱动模块的电源就分开了。你觉得这样的设计怎么样？

总结：
这次要做一个有操作系统的智能控制模块，以后会在树莓派上面加上摄像头，红外探测器等很多模块。



小车控制
https://github.com/lexuszhi1990/node-wiring-pi

> npm install wiring-pi

var wpi = require('wiring-pi');
wpi.setup();
wpi.setup('gpio');

wpi.pinMode(0, wpi.modes.OUTPUT);wpi.pinMode(7, wpi.modes.OUTPUT);
wpi.pinMode(2, wpi.modes.OUTPUT);wpi.pinMode(3, wpi.modes.OUTPUT);
wpi.pinMode(1, wpi.modes.OUTPUT);wpi.pinMode(4, wpi.modes.OUTPUT);
wpi.pinMode(5, wpi.modes.OUTPUT);wpi.pinMode(6, wpi.modes.OUTPUT);

wpi.digitalWrite(0, wpi.LOW); wpi.digitalWrite(7, wpi.LOW);
左上轮子
pin 0  后退 wpi.digitalWrite(0, wpi.HIGH);
    7  前进 wpi.digitalWrite(7, wpi.HIGH);

wpi.pinMode(2, wpi.modes.OUTPUT);wpi.pinMode(3, wpi.modes.OUTPUT);
wpi.digitalWrite(2, wpi.LOW); wpi.digitalWrite(3, wpi.LOW);
左下轮子
pin 2 后退 wpi.digitalWrite(2, wpi.HIGH);
    3 前进 wpi.digitalWrite(3, wpi.HIGH);

wpi.pinMode(1, wpi.modes.OUTPUT);wpi.pinMode(4, wpi.modes.OUTPUT);
wpi.digitalWrite(1, wpi.LOW); wpi.digitalWrite(4, wpi.LOW);
右上轮子
pin 1 后退 wpi.digitalWrite(1, wpi.HIGH);
    4 前进 wpi.digitalWrite(4, wpi.HIGH);

wpi.pinMode(5, wpi.modes.OUTPUT);wpi.pinMode(6, wpi.modes.OUTPUT);
wpi.digitalWrite(5, wpi.LOW); wpi.digitalWrite(6, wpi.LOW);
右下轮子
pin 6 后退 wpi.digitalWrite(6, wpi.HIGH);
    5 前进 wpi.digitalWrite(5, wpi.HIGH);
