如果你要用ubuntu的引导器代替windows的引导器，就选/dev/sda。
如果你要保留windows的引导器，就选/boot分区，但这样一来，装完ubuntu重启后，只能启动windows，还必须在windows上面安装easybcd、grub4dos等等之类软件来添加ubuntu启动项。

分区的顺序最好是把boot分区靠前，swap分区最后。如果是整个硬盘安装一套Linux系统，一般来讲boot放到最前面，并且把boot设置为主分区，其它都设置为逻辑分区。如果是双系统或多系统安装，一般都选择逻辑分区即可。

分区类型

1、/分区。用于存储系统文件。
2、swap，即交换分区，也是一种文件系统，它的作用是作为Linux的虚拟内存。
在Windows下，虚拟内存是一个文件：pagefile.sys；而Linux下，虚拟内存需要使用独立分区，这样做的目的据说是为了提高虚拟内存的性能。
3、/boot：包含了操作系统的内核和在启动系统过程中所要用到的文件。
在很多老旧的教程中，都会让用户在/boot目录上挂载一个大小为100MB左右的独立分区，并推荐把该/boot放在硬盘的前面——即1024柱面之 前。事实上，那是Lilo无法引导1024柱面后的操作系统内核的时代的遗物了。当然，也有人说，独立挂载/boot的好处是可以让多个Linux共享一 个/boot。
其实，无论是基于上述的哪种理由，都没有必要把/boot分区独立出来。首先，Grub可以引导1024柱面后的Linux内核；其次，即使是安装有多个 Linux，也完全可以不共享/boot。因为/boot目录的大小通常都非常小，大约20MB，分一个100MB的分区无疑是一种浪费，而且还把把硬盘 分的支离破碎的，不方便管理。另外，如果让两个Linux共享一个/boot，每次升级内核，都会导致Grub的配置文件冲突，带来不必要的麻烦。而且， 不独立/boot分区仅仅占用了根目录下的大约20MB左右的空间，根本不会对根目录的使用造成任何影响。
但值得注意的是，随着硬盘容量的增大，无法引导Linux内核的现象再次出现，这也就是著名的137GB限制。很遗憾，Grub是无法引导137GB之后 的分区中的Linux内核的。如果你不巧遇到了这样的情况，你就要考虑把/boot独立挂载到位于137GB前方的独立分区中，或者索性就把 Linux的分区都往前移动，让根目录所在分区位于137GB之前。
4、/usr/local：是 Linux系统存放软件的地方。
建议把/opt，/usr或/usr/local独立出来的教程，基本上也是非常老的了。使用Ubuntu时，我们一般都是使用系统的软件包管理器安装软 件，很少自己编译安装软件。而建议独立/usr，/opt，/usr/local的理由无非是为了重装系统时不再重新编译软件而直接使用早先编译的版本。 不过对于大多数普通用户来说，这个建议通常是没有意义的。
5、/var：是系统日志记录分区。
6、/tmp分区，用来存放临时文件。
建议把/var和/tmp独立出来的教程通常是面向服务器的。因为高负载的服务器通常会产生很多日志文件、临时文件，这些文件经常改变，因此把/var， /tmp独立出来有利于提高服务器性能。但我们用Ubuntu是做桌面的，甚至有些用户根本从来没有关心过系统日志这玩意儿，所以根本没有必要独立的为 /var和/tmp挂载分区。
7、/home：是用户的home目录所在地。
这可能是唯一一个值得独立挂载分区的目录了。/home是用户文件夹所在的地方。一个用户可能在/home/user中存放了大量的文件资料，如果独立挂 载/home，即使遇到Ubuntu无故身亡的尴尬局面，也可以立刻重装系统，取得自己的文件资料。因此，/home是唯一可以考虑独立挂载分区的目录。
有些老旧的教程中建议把Linux安装在主分区中，或在/boot下挂载一个主分区。事实上，这也是不需要的。Linux的所有分区都可以位于逻辑分区中。所以不要再为这些旧教程所误导了，不要再浪费有限的主分区了，放心的把Linux安装在逻辑分区中

Ubuntu Linux可以把分区作为挂载点，载入目录，其中最常用的目录如下表所示：

目录  建议大小  格式  描述
/ 10G-20G ext4  根目录
swap  <2048M  swap  交换空间
/boot 200M左右  ext4  Linux的内核及引导系统程序所需要的文件，比如 vmlinuz initrd.img文件都位于这个目录中。在一般情况下，GRUB或LILO系统引导管理器也位于这个目录；启动撞在文件存放位置，如kernels，initrd，grub。
/tmp  5G左右  ext4  系统的临时文件，一般系统重启不会被保存。（建立服务器需要？）
/home 尽量大些  ext4  用户工作目录；个人配置文件，如个人环境变量等；所有账号分配一个工作目录。

目录  建议大小  格式  描述
/ 10G-20G ext4  根目录
swap  <2048M  swap  交换空间
/boot 200M左右  ext4  Linux的内核及引导系统程序所需要的文件，比如 vmlinuz initrd.img文件都位于这个目录中。在一般情况下，GRUB或LILO系统引导管理器也位于这个目录；启动撞在文件存放位置，如kernels，initrd，grub。
/tmp  5G左右  ext4  系统的临时文件，一般系统重启不会被保存。（建立服务器需要？）
/home 尽量大些  ext4  用户工作目录；个人配置文件，如个人环境变量等；所有账号分配一个工作目录。


|大小 |新分区的类型|新分区的位置|用于|挂载点|用途|
|---- |----------|-----------|---|------|----|
|200MB|逻辑分区|空间起始位置|Ext4日志文件系统|/boot|引导分区|
|20G|逻辑分区|空间起始位置|Ext4日志文件系统 |/|用于存放系统相当于win10的C盘|
|16G|逻辑分区|空间起始位置|交换空间|/swap|相当于电脑内存|
|所有剩余的空间|逻辑分区|空间起始位置|Ext4日志文件系统|/home|用户存储数据用|
