---
layout: post
title: "python basic usages"
date: 2018-03-09 22:13:23 +0800
comments: true
categories: [dev]
tags: [python]
---


### install python 3.6

```
sudo add-apt-repository ppa:jonathonf/python-3.6
sudo apt-get update
sudo apt-get install python3.6

sudo ln -s /usr/bin/python3.5 /usr/bin/python3
```

### pip


### Python搜索模块路径

```
import sys
print(sys.path)
```

1)、程序的主目录
2)、PTYHONPATH目录（如果已经进行了设置）
3)、标准连接库目录（一般在/usr/local/lib/python2.X/）
4)、任何的.pth文件的内容（如果存在的话）.新功能，允许用户把有效果的目录添加到模块搜索路径中去.pth后缀的文本文件中一行一行的地列出目录。
