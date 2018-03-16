---
layout: post
title: markdown usages
date: 2015-09-20 17:01
categories: [dev, markdown]
published: false
---

markdown: redcarpet
redcarpet:
  extensions: ["tables"]

### tables

|方法                                | 每秒执行的次数 | 相差的倍数       |
| :-------------------------------- | :----------- | :------------- |
|raw_insert:                        | 44.5 i/s     |                |
|import without model validations:  | 2.1 i/s      | - 21.60x slower|
|import with model validations:     | 0.9 i/s      | - 47.50x slower|
|save without validations:          | 0.2 i/s      | - 245.60x slower|
|batch create:                      | 0.2 i/s      | - 248.77x slower|
|save with validations:             | 0.2 i/s      | - 281.06x slower|

or

方法                                | 每秒执行的次数 | 相差的倍数
 :-------------------------------- | :----------- | :-------------
raw_insert:                        | 44.5 i/s     |
import without model validations:  | 2.1 i/s      | - 21.60x slower
import with model validations:     | 0.9 i/s      | - 47.50x slower
save without validations:          | 0.2 i/s      | - 245.60x slower
batch create:                      | 0.2 i/s      | - 248.77x slower
save with validations:             | 0.2 i/s      | - 281.06x slower

其中
`:--------------------------------` 表示左对齐
`--------------------------------:` 表示右对齐
`:--------------------------------:` 表示居中


### images
![My helpful screenshot]({{ site.url }}/img/about-bg.jpg)
