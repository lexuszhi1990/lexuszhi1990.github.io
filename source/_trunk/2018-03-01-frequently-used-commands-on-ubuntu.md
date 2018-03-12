---
layout: post
title: "frequently-used commands on ubuntu"
date: 2014-01-23 21:07:30 +0800
comments: true
categories: [dev, css, sass]
---

### imagemagic
install imagemagic: `apt-get install imagemagick`

查询对应图片的信息 `identify logo.jpg `

缩放图像 `convert -resize 20%x20% test.JPG test-small.png`

### 查看磁盘使用

`df -lh`

### 查看磁盘挂载情况

`fdisk -l`

### 查看占用端口

netstat -apn|grep 80

lsof -i:21

### 解压缩

extract files
```
tar xzf file.tar.gz
tar xjf file.tar.bz2
```
