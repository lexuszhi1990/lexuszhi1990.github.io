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

### 用户管理

打开终端 `useradd -m david`
创建 `david` 用户, 且创建 home目录

设置用户密码 `passwd david`

添加到sudo组 `usermod -a -G sudo david`
-a 添加  -G添加到组

修改bash
`sudo chsh /bin/bash david`

http://jingyan.baidu.com/article/5d368d1ef58ed43f60c05727.html
http://www.cnblogs.com/daizhuacai/archive/2013/01/17/2865132.html

### install opencv on mac

`brew install opencv`

update numpy to latest
`sudo easy_install -U numpy`

http://stackoverflow.com/questions/1520379/how-to-update-numpy-on-mac-os-x-snow-leopard

### scp

scp 本地用户名 @IP 地址 : 文件名 1 远程用户名 @IP 地址 : 文件名 2

[ 本地用户名 @IP 地址 :] 可以不输入 , 可能需要输入远程用户名所对应的密码 .

可能有用的几个参数 :

-v 和大多数 linux 命令中的 -v 意思一样 , 用来显示进度 . 可以用来查看连接 , 认证 , 或是配置错误 .

-C 使能压缩选项 .

-P 选择端口 . 注意 -p 已经被 rcp 使用 .

-4 强行使用 IPV4 地址 .

-6 强行使用 IPV6 地址 .

### cpu kernels

http://blog.csdn.net/cbmsft/article/details/7219370
http://www.cnblogs.com/emanlee/p/3587571.html

1.具有相同core id的cpu是同一个core的超线程。
2.具有相同physical id的cpu是同一颗cpu封装的线程或者cores。
英文版：
1.Physical id and core id are not necessarily consecutive but they are unique. Any cpu with the same core id are hyperthreads in the same core.
2.Any cpu with the same physical id are threads or cores in the same physical socket.

总核数 = 物理CPU个数 X 每颗物理CPU的核数
总逻辑CPU数 = 物理CPU个数 X 每颗物理CPU的核数 X 超线程数

查看物理CPU个数
`cat /proc/cpuinfo| grep "physical id"| sort| uniq| wc -l` :

查看每个物理CPU中core的个数(即核数)
`cat /proc/cpuinfo| grep "cpu cores"| uniq` :

查看逻辑CPU的个数
`cat /proc/cpuinfo| grep "processor"| wc -l` :


查看当前操作系统内核信息
`uname -a` :
Linux redcat 2.6.31-20-generic #58-Ubuntu SMP Fri Mar 12 05:23:09 UTC 2010 i686 GNU/Linux

查看当前操作系统发行版信息
#cat /etc/issue
Ubuntu 9.10 \n \l

查看cpu型号
`cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c` :
2  Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
(看到有2个逻辑CPU, 也知道了CPU型号)

查看物理cpu颗数
`cat /proc/cpuinfo | grep physical | uniq -c`
2 physical id    : 0
(说明实际上是1颗2核的CPU)

查看cpu运行模式
`getconf LONG_BIT`
32
(说明当前CPU运行在32bit模式下, 但不代表CPU不支持64bit)

查看cpu是否支持64bit
`cat /proc/cpuinfo | grep flags | grep ' lm ' | wc -l` :
2
(结果大于0, 说明支持64bit计算. lm指long mode, 支持lm则是64bit)

查看cpu信息概要（昨天看aix的时候刚发现的，在ubuntu上竟然也有~）:
#lscpu

```
Architecture:          i686                            #架构686
CPU(s):                2                                   #逻辑cpu颗数是2
Thread(s) per core:    1                           #每个核心线程数是1
Core(s) per socket:    2                           #每个cpu插槽核数/每颗物理cpu核数是2
CPU socket(s):         1                            #cpu插槽数是1
Vendor ID:             GenuineIntel           #cpu厂商ID是GenuineIntel
CPU family:            6                              #cpu系列是6
Model:                 23                                #型号23
Stepping:              10                              #步进是10
CPU MHz:               800.000                 #cpu主频是800MHz
Virtualization:        VT-x                         #cpu支持的虚拟化技术VT-x(对此在下一博文中解释下http://hi.baidu.com/sdusoul/blog/item/5d8e0488def3a998a5c272c0.html)
L1d cache:             32K                         #一级缓存32K（google了下，这具体表示表示cpu的L1数据缓存为32k）
L1i cache:             32K                          #一级缓存32K（具体为L1指令缓存为32K）
L2 cache:              3072K                      #二级缓存3072K
```

### locale

http://my.oschina.net/u/943306/blog/345923

```
perl: warning: Setting locale failed.
perl: warning: Please check that your locale settings:
        LANGUAGE = (unset),
        LC_ALL = (unset),
        LC_TIME = "zh_CN.UTF-8",
        LC_MONETARY = "zh_CN.UTF-8",
        LC_CTYPE = "UTF-8",
        LC_ADDRESS = "zh_CN.UTF-8",
        LC_TELEPHONE = "zh_CN.UTF-8",
        LC_NAME = "zh_CN.UTF-8",
        LC_MEASUREMENT = "zh_CN.UTF-8",
        LC_IDENTIFICATION = "zh_CN.UTF-8",
        LC_NUMERIC = "zh_CN.UTF-8",
        LC_PAPER = "zh_CN.UTF-8",
        LANG = "en_US.UTF-8"
    are supported and installed on your system.
perl: warning: Falling back to the standard locale ("C").
locale: Cannot set LC_CTYPE to default locale: No such file or directory
locale: Cannot set LC_ALL to default locale: No such file or directory
```


客户机一般都会设置zh_CN.UTF-8语言，用来显示中文，而远端的vps一般就只有en_US.UTF-8
zh_CN.UTF-8一旦带过去就会报找不到的错误，文章开头已经说的很清楚了

网上还有些解决方法，并不是很靠谱，虽然从表面来看像解决问题了，但其实是把问题影藏了

比如在远程主机上的/etc/ssh/sshd_config文件里，将AcceptEnv LANG LC_*这行注释掉
然后重启远程的sshd，然后退出远程后，重新ssh上来。
这时，远程主机不会把客户机的语言环境（zh_CN.UTF-8）带过来
当然就不会再有报错，可惜的是，远程主机是无法正确显示中文的，问题还在，只是被影藏了。

```
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales
```

check locale : `perl -e exit`
