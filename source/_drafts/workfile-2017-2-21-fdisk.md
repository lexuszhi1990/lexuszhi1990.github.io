---
layout: post
title: "ubuntu disk management"
date: 2018-03-09 22:13:23 +0800
comments: true
categories: [dev]
tags: [python]
---

# 查看硬盘并自动挂载

1) 显示硬盘及所属分区情况。在终端窗口中输入如下命令：

`$ sudo fdisk -lu`

输出：
```
Disk /dev/sda: 465.8 GiB, 500107862016 bytes, 976773168 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x0003182b

Device     Boot     Start       End   Sectors   Size Id Type
/dev/sda1  *         2048  97656831  97654784  46.6G 83 Linux
/dev/sda2        97658878 976771071 879112194 419.2G  5 Extended
/dev/sda5        97658880 957243391 859584512 409.9G 83 Linux
/dev/sda6       957245440 976771071  19525632   9.3G 82 Linux swap / Solaris
```

### 格式化

```
mkfs.xfs -i size=512 /dev/sdb1
mkdir -p /data/brick1
echo '/dev/sdb1 /data/brick1 xfs defaults 1 2' >> /etc/fstab
mount -a && mount
```

### 设置开机自动挂载

a) /etc/fstab文件格式：6个组成部分

`sudo vim /etc/fstab`

 <file system> <mount point>   <type>  <options>       <dump>      <pass>

      1              2          3         4             5           6
1 指代文件系统的设备名。最初，该字段只包含待挂载分区的设备名（如/dev/sda1）。现在，除设备名外，还可以包含LABEL或UUID
2 文件系统挂载点。文件系统包含挂载点下整个目录树结构里的所有数据，除非其中某个目录又挂载了另一个文件系统
3 文件系统类型。下面是多数常见文件系统类型（ext3,tmpfs,devpts,sysfs,proc,swap,vfat）
4 mount命令选项。mount选项包括noauto（启动时不挂载该文件系统）和ro（只读方式挂载文件系统）等。在该字段里添加用户或属主选项，即可允许该用户挂载文件系统。多个选项之间必须用逗号隔开。其他选项的相关信息可参看mount命令手册页（-o选项处）
5转储文件系统？该字段只在用dump备份时才有意义。数字1表示该文件系统需要转储，0表示不需要转储
6文件系统检查？该字段里的数字表示文件系统是否需要用fsck检查。0表示不必检查该文件系统，数字1示意该文件系统需要先行检查（用于根文件系统）。数字2则表示完成根文件系统检查后，再检查该文件系统

b) blkid获取分区的uuid

```
$ sudo blkid
/dev/sda1: UUID="839e48eb-5dd5-47fb-93b6-1fbd3a06ed3a" TYPE="ext4" PARTUUID="0003182b-01"
/dev/sda5: UUID="c37c741b-7c23-4678-a396-f2419d875526" TYPE="ext4" PARTUUID="0003182b-05"
/dev/sda6: UUID="7f46aef5-3f0e-438d-a453-b0c55ae4f562" TYPE="swap" PARTUUID="0003182b-06"
/dev/sdb1: PARTLABEL="Microsoft reserved partition" PARTUUID="33969ff2-bed2-46fa-968f-96e66204e2c0"
/dev/sdb2: LABEL="data" UUID="425E68A45E689289" TYPE="ntfs" PARTLABEL="Basic data partition" PARTUUID="ce98a22d-9d24-425d-8a21-848199427bda"
```

c) 此时要挂载硬盘

例如要挂载 /dev/sdb2 只需要在 /etc/fstab 文件中，添加一行

`UUID=425E68A45E689289 /mnt/inside-4T  ntfs    defaults        0       0`
dsd

d) 检查fstab正确性，sudo mount -a

```
sudo df -lh

#=> /dev/sdb2      3906885628 737432256 3169453372  19% /mnt/inside-4T
```
则挂载成功。

e) 挂载失败导致无法启动的解决办法

开机启动时候长按 shift 键进入recovery mode
是因为Linux在挂载/etc/fstab所在的设备时，把挂载属性设置为了只读。所以只需要重新挂载一下/etc/fstab所在的设备，并把属性设置为可读写，就可以修改/etc/fstab文件了。

重新挂载设备，设置可读写：`mount -o remount, rw /dev/sda1` 或者 `mount -rw -o remount /
`
然后修改/etc/fstab 后，重启即可。

f) (optional) 查看文件夹大小

`du -h /mnt/inside-1T/ --max-depth=1`


### gpt mount

传统的对硬盘进行分区需要在终端敲sudo fdisk进行操作，但是，当挂载的硬盘的容量大于2T的时候，是无法通过sudo fdisk进行分区的，这个时候必须要进行GPT进行分区
https://unix.stackexchange.com/questions/38164/create-partition-aligned-using-parted

```
sudo parted -a optimal /dev/sda #进入parted
mklabel gpt #将磁盘设置为gpt格式，
mkpart logical 0 -1 #将磁盘所有的容量设置为GPT格式
mkpart primary 0% 4096MB
mkpart logical 0% 1799168MB
mkpart logical 0% 3999168MB
print #查看分区结果
quit
```

```
sudo fdisk -lu
sudo mkfs -t ext4 /dev/sda1
sudo blkid /dev/sda1
```

```
# /etc/etc/fstab
UUID=97dc5f3d-c2c1-40e7-be51-13fcc8085b25 /mnt/workplace  ext4    defaults        0       0
```
