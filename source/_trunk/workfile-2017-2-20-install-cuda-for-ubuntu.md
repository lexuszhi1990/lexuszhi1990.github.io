# install cuda/tensorflow for ubuntu

### 安装nvidia显卡驱动

1. 去Nvidia官方网站下载最新的驱动

  最好下载run文件 `NVIDIA-Linux-x86_64-375.39.run`

2. 禁用ubuntu自带显卡驱动

  终端运行：`$ lsmod | grep nouveau`，如果有输出则代表 `nouveau` 加载。

  ```
  nouveau              1495040  4
  mxm_wmi                16384  1 nouveau
  video                  40960  1 nouveau
  i2c_algo_bit           16384  1 nouveau
  ttm                    94208  1 nouveau
  drm_kms_helper        147456  1 nouveau
  drm                   360448  7 ttm,drm_kms_helper,nouveau
  wmi                    20480  2 mxm_wmi,nouveau
  ```

  Ubuntu的`nouveau`禁用方法：(这里说法不一，有的是`/etc/modprobe.d/`目录下的 `blacklist-nouveau.conf` 文件，有的说是 `blacklist.conf` 文件，有的是跟显卡驱动版本对应的文件)。在`/etc/modprobe.d/`中创建对应的文件，在文件中输入一下内容

  ```
  sudo vi /etc/modprobe.d/blacklist.conf
  # 加入这几行
  blacklist nouveau
  options nouveau modeset=0
  ```
  终端运行 `$ sudo update-initramfs -u`
  运行完毕之后 `$ lsmod | grep nouveau` 依然有输出，重启之后就没有了。

  设置完毕可以再次运行 `$ lsmod | grep nouveau` 检查是否禁用成功，如果运行后没有任何输出，则代表禁用成功。
  注：这种方式也可能不能彻底禁用nouveau，在此基础上可以移除以下文件，以防万一，其中xxxxxx为你的版本文件，自己根据路径查看一下就可以了`/lib/modules/xxxxxxxx/kernel/drivers/gpu/drm/nouveau/nouveau.ko`
  `/lib/modules/xxxxxxxx/kernel/drivers/gpu/drm/nouveau/nouveau.ko.org `第二位文件一般是隐藏的。具体操作：

  ```
  $ cd /lib/modules/xxxxxxxx/kernel/drivers/gpu/drm/nouveau
  $ sudo rm -rf nouveau.ko
  $ sudo rm -rf nouveau.ko.org
  # 再更新
  $ sudo update-initramfs –u
  ```

  如果`$ lsmod | grep nouveau`还有输出，可以考虑卸载官方驱动nouveau
  `sudo apt-get --purge remove xserver-xorg-video-nouveau`
  或者使用`prime-select`来选择显卡驱动（http://www.cnblogs.com/platero/p/4070756.html）

3. 卸载已经安装的nvidia显卡驱动
  如果已经有安装了nvidia显卡驱动，卸载可能会更安全一点

  ```
  # 清除nvidia相关的软件（如果有的话）
  sudo apt-get --purge remove nvidia-*
  # 如果安装的是官网下载的驱动，则可以重新运行run文件来卸载
  sh ./nvidia.run --uninstall
  ```

  根据这三篇文章,卸载nvida驱动的命令是：
  http://www.cnblogs.com/platero/p/4070756.html
  http://askubuntu.com/questions/206283/how-can-i-uninstall-a-nvidia-driver-completely
  http://blog.csdn.net/luzhyi/article/details/23865713

  ```
  sudo apt-get remove --purge nvidia-*
  sudo apt-get install ubuntu-desktop
  sudo rm /etc/X11/xorg.conf
  echo 'nouveau' | sudo tee -a /etc/modules
  ```

  最后一个命令是还原ubuntu原生的显卡驱动, 可以不执行(`If you want to be sure that nouveau will be load in boot, you can force-load it by add it to /etc/modules`)

4. 退出x界面进入命令行控制台

  重启电脑，到达登录界面时，`alt+ctrl+f1`，进入`text mode`，登录账户

  终端输入 `sudo service lightdm stop`  关闭图形化界面

5. 安装nvidia驱动

  `sudo sh NVIDIA-Linux-x86_64-195.36.24-pkg2.run`

  安装过程中
  如果提示有旧驱动，询问是否删除旧驱动，选Yes；
  如果提示缺少某某模块（modules），询问是否上网下载，选no；

  如果提示编译模块，询问是否进行编译，选ok；
  如果提示将要修改Xorg.conf，询问是否允许，选Yes；

  Would you like to run the nvidia-xconfig utility to automatically update your X
  configuration file so that the NVIDIA X driver will be used when you restart X?
  Any pre-existing X configuration file will be backed up. (yes)

6. 重启跟新驱动
  如果不重启 `nvidia-smi` 命令是找不到的。重启之后就有了。
  终端输入 `sudo service lightdm start`  开启图形化界面，然后重启是否安装成功


### 安装cuda 8.0

a) 重启电脑，到达登录界面时，`alt+ctrl+f1`，进入`text mode`，登录账户

b) 再次运行 `$ lsmod | grep nouveau` 确认是否禁用成功，如果运行后没有任何输出，则代表禁用成功。

c) 输入 `$ sudo service lightdm stop` 关闭图形化界面

d) `$ sudo sh cuda_8.0.61_375.26_linux.run`

按照提示一步步操作, 遇到提示是否安装openGL，选择no（电脑是双显，且主显是非NVIDIA的GPU需要选择no，否则可以yes），其他都选择yes或者默认。安装成功后，会显示installed，否则会显示failed。

Do you want to run nvidia-xconfig?
This will update the system X configuration file so that the NVIDIA X driver
is used. The pre-existing X configuration file will be backed up.
This option should not be used on systems that require a custom
X configuration, such as systems with multiple GPU vendors.
(y)es/(n)o/(q)uit [ default is no ]:
这个不知道是什么意思，就按默认来的。

这是安装完之后的输出,里面有讲如何卸载cuda。在跟新之前一定要卸载前一版本的。
```
===========
= Summary =
===========

Driver:   Installed
Toolkit:  Installed in /usr/local/cuda-8.0
Samples:  Not Selected

Please make sure that
 -   PATH includes /usr/local/cuda-8.0/bin
 -   LD_LIBRARY_PATH includes /usr/local/cuda-8.0/lib64, or, add /usr/local/cuda-8.0/lib64 to /etc/ld.so.conf and run ldconfig as root

To uninstall the CUDA Toolkit, run the uninstall script in /usr/local/cuda-8.0/bin
To uninstall the NVIDIA Driver, run nvidia-uninstall

Please see CUDA_Installation_Guide_Linux.pdf in /usr/local/cuda-8.0/doc/pdf for detailed information on setting up CUDA.
```

e) 配置cuda

```
echo "
# cuda conf
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/e
export CUDA_HOME=/usr/local/cuda # for tf
" >> ~/.zshrc
```
然后打开一个新的窗口

```
$ nvcc -V
#=>  nvcc: NVIDIA (R) Cuda compiler driver
      Copyright (c) 2005-2016 NVIDIA Corporation
      Built on Tue_Jan_10_13:22:03_CST_2017
      Cuda compilation tools, release 8.0, V8.0.61
```

### install tensorflow

Ubuntu/Linux 64-bit for pip install tensorflow
`$ sudo apt-get install python-pip python-dev python-virtualenv -y`
`$ sudo apt-get install python-numpy python-dev python-wheel python-mock -y`

Requires CUDA toolkit 8.0 and CuDNN v5. For other versions, see "Installing from sources" below.

```
$ export TF_BINARY_URL=https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.0.0-cp27-none-linux_x86_64.whl
$ pip install --upgrade $TF_BINARY_URL
```

Enable GPU Support. You also need to set the LD_LIBRARY_PATH and CUDA_HOME environment variables. Consider adding the commands below to your `~/.bash_profile`(这里是你的login之后的shell config 文件，可以是 `.zshrc` 或者其他).

```
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"
export CUDA_HOME=/usr/local/cuda
```

Uncompress and copy the cuDNN files into the toolkit directory. Assuming the toolkit is installed in /usr/local/cuda, run the following commands

```
tar xvzf cudnn-8.0-linux-x64-v5.1.tgz
sudo cp -P cudnn-v5.1.3/include/cudnn.h /usr/local/cuda/include/
sudo cp -P cudnn-v5.1.3/lib64/libcudnn* /usr/local/cuda/lib64/
sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
```

test tensorflow

```
$ python
...
import tensorflow as tf
hello = tf.constant('Hello, TensorFlow!')
sess = tf.Session()
print(sess.run(hello))
>>> Hello, TensorFlow!
a = tf.constant(10)
b = tf.constant(32)
print(sess.run(a + b))
>>> 42
```

references
----------

http://blog.csdn.net/l297969586/article/details/53320706
http://blog.csdn.net/masa_fish/article/details/51882183
https://developer.nvidia.com/cuda-downloads
https://developer.nvidia.com/rdp/cudnn-download
http://www.nvidia.cn/Download/index.aspx?lang=cn
https://www.tensorflow.org/install/install_linux
