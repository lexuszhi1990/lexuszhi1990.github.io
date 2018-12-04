---
layout: post
title: "frequently-used commands on ubuntu"
date: 2014-01-23 21:07:30 +0800
comments: true
categories: [dev]
---

### imagemagic
install imagemagic: `apt-get install imagemagick`

查询对应图片的信息 `identify logo.jpg `

缩放图像 `convert -resize 20%x20% test.JPG test-small.png`

<!-- more -->

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

备份系统：
`tar -cvpzf /os_backup/ubuntu14_ver0.1.tar.gz --exclude=os_backup --exclude=proc --exclude=tmp --exclude=mnt --exclude=sys --exclude=lost+found / > /dev/null`
'tar' 是用来备份的程序
c - 新建一个备份文档
v - 详细模式， tar程序将在屏幕上实时输出所有信息。
p - 保存许可，并应用到所有文件。
z - 采用‘gzip’压缩备份文件，以减小备份文件体积。
f - 说明备份文件存放的路径， Ubuntu.tgz 是本例子中备份文件名。
“/”是我们要备份的目录，在这里是整个文件系统。

还原系统：
`tar -xvpzf /os_backup/ubuntu14_ver0.1.tar.gz -C /your-dir`
-C 参数是指定tar程序解压缩到的目录。

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


### 批量修改文件

Usage：rename [-v] [-n] [-f] perlexpr [filenames]

-v(verbose)打印被成功重命名的文件
-n(no-act)只显示将被重命名的文件，而非实际进行重命名操作
-f(force)覆盖已经存在的文件
perlexprPerl语言格式的正则表达式
files需要被替换的文件(比如*.c、*.h)，如果没给出文件名，将从标准输入读

`rename -n 's/[()]//g' *.jpg`

解释：
-n直接打印结果在终端中而非实际执行
引号中是perl的正则表达式，用来匹配和替换，s代表substitution，替换的意思
[()]代表匹配[]中的内容
//两个斜杠之间是空代表替换为空的内容，相当于删除
g代表全部匹配，不加g的话默认只会匹配一个括号


`rename -n 's/^/test_/' *.jpg`

s-替换
^-在文件名称开头加字符
test_-将名称前面添加上test_

```
# 将所有*.nc文件中Sam3替换成Stm32
rename -v 's/Sam3/Stm32/' *.nc　　/*执行修改，并列出已重命名的文件*/

# 去掉文件后缀名(比如去掉.bak)
rename 's/\.bak$//' *.bak

# 将文件名改为小写
rename 'y/A-Z/a-z/' *

# 去掉文件名的空格
rename 's/[ ]+//g' *

# 文件开头加入字符串(比如jelline)
rename 's/^/jelline/' *

# 文件末尾加入字符串(比如jelline)
rename 's/$/jelline/' *
```

正则表达式中的一些常用模式pattern[2]：

```
x? 　匹配 0 次或一次 x 字符串

x* 　匹配 0 次或多次 x 字符串，但匹配可能的最少次数

x+ 　匹配 1 次或多次 x 字符串，但匹配可能的最少次数

.* 　匹配 0 次或一次的任何字符

.+ 　匹配 1 次或多次的任何字符

{m}　匹配刚好是 m 个 的指定字符串

{m,n}匹配在 m个 以上 n个 以下 的指定字符串

{m,} 匹配 m个 以上 的指定字符串

[] 　匹配符合 [] 内的字符

[^]　匹配不符合 [] 内的字符

[0-9]匹配所有数字字符

[a-z]匹配所有小写字母字符

[^0-9]匹配所有非数字字符

[^a-z]匹配所有非小写字母字符

^ 　　匹配字符开头的字符

$ 　　匹配字符结尾的字符

\d　　匹配一个数字的字符，和 [0-9] 语法一样

\d+ 　匹配多个数字字符串，和 [0-9]+ 语法一样

\D　　非数字，其他同 \d

\D+　 非数字，其他同 \d+

\w 　 英文字母或数字的字符串，和 [a-zA-Z0-9] 语法一样

\w+ 　和 [a-zA-Z0-9]+ 语法一样

\W 　 非英文字母或数字的字符串，和 [^a-zA-Z0-9] 语法一样

\W+   和 [^a-zA-Z0-9]+ 语法一样

\s    空格，和 [\n\t\r\f] 语法一样

\s+   和 [\n\t\r\f]+ 一样

\S    非空格，和 [^\n\t\r\f] 语法一样

\S+   和 [^\n\t\r\f]+ 语法一样

\b    匹配以英文字母,数字为边界的字符串

\B    匹配不以英文字母,数值为边界的字符串

a|b|c 匹配符合a字符 或是b字符 或是c字符 的字符串

abc   匹配含有 abc 的字符串

```

### initramfs-tools

在处理时有错误发生：
 initramfs-tools
E: Sub-process /usr/bin/dpkg returned an error code (1)
dpkg --get-selections|grep linux 查看所有安装的内核，并把带 install 的卸载掉
sudo apt-get remove linux-image-2.6.24-16-generic

dpkg --get-selections|grep linux
sudo apt-get remove linux-image-4.15.0-20-generic

### umount: target is busyl

fuser -m -v -i -k /dev/sdb1

### format sd card(mac)

`sudo diskutil eraseDisk FAT32 RASPBIAN MBRFormat /dev/disk2`

https://www.raspberrypi.org/documentation/installation/installing-images/mac.md


### remove apt-key

https://askubuntu.com/questions/604988/how-to-remove-a-apt-key-which-i-have-added

sudo apt-key list | grep 'Gluster'
sudo apt-key del 6A7BD8D4


### dd 磁盘速度测试

HDD写性能：
```
dd if=/dev/zero of=/home/train/test.dbf bs=8k count=2000000 conv=fdatasync
2000000+0 records in
2000000+0 records out
16384000000 bytes (16 GB, 15 GiB) copied, 71.7024 s, 229 MB/s
```

HDD读性能：

dd if=/home/train/test.dbf of=/dev/null bs=8k count=2000000 iflag=direct

http://elf8848.iteye.com/blog/2089055


|type|read speed|write speed|
|----|----------|-----------|
|SSD|291.11 MB/s|252 MB/s|
|hdd|119.88 MB/s|80.2 MB/s|

```
train@train22:/data/brick2/workspace$ sudo hdparm -Tt /dev/sda

/dev/sda:
 Timing cached reads:   19484 MB in  2.00 seconds = 9749.91 MB/sec
 Timing buffered disk reads: 874 MB in  3.00 seconds = 291.11 MB/sec
train@train22:/data/brick2/workspace$ sudo hdparm -Tt /dev/sdc1

/dev/sdc1:
 Timing cached reads:   18798 MB in  2.00 seconds = 9407.60 MB/sec
 Timing buffered disk reads: 360 MB in  3.00 seconds = 119.88 MB/sec


SSD write:
train@train22:~$ dd if=/dev/zero of=/home/train/test.dbf bs=8k count=2000000 conv=fdatasync
2000000+0 records in
2000000+0 records out
16384000000 bytes (16 GB, 15 GiB) copied, 65.0601 s, 252 MB/s


train@train22:/data/brick2/workspace$ dd if=/dev/zero of=/data/brick2/test3.dbf bs=8k count=2000000  conv=fdatasync
2000000+0 records in
2000000+0 records out
16384000000 bytes (16 GB, 15 GiB) copied, 204.218 s, 80.2 MB/s

iflag=direct
```

### ubuntu 挂载 samba 磁盘

1.下载samba相应组件：
`sudo apt-get install cifs-utils`

2.查看共享目录：
`smbclient -L 192.168.0.103 -N`

3.挂载
(username=服务器的名字，密码=服务器密码，IP地址＝自己服务器的IP)
`sudo mount -t cifs -o username=用户名,password=密码 //IP地址/Code /home/liyan/smb_code`
