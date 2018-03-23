

#### 禁用系统自带nouveau驱动。

```
$ sudo vim /etc/modprobe.d/blacklist-nouveau.conf

    # update blacklist and ptions
    blacklist nouveau
    ptions nouveau modeset=0

# update kernel
$ sudo update-initramfs -u
```

### 安装cuDNN
安装前请去先[官网下载](https://developer.nvidia.com/cudnn)最新的cuDNN。

接然解压文件即可：`$ tar xvf cudnn-7.5-linux-x64-v5.0-ga.tgz`

使用ldconfig方法 链接cuDNN的库文件。

```
sudo cp cudnn.h /usr/local/include
sudo cp libcudnn.so /usr/local/lib
sudo cp libcudnn.so.7.0 /usr/local/lib
sudo cp libcudnn.so.7.0.64 /usr/local/lib
sudo ln -sf /usr/local/lib/libcudnn.so.7.0.64 \
 /usr/local/lib/libcudnn.so.7.0
sudo ln -sf /usr/local/lib/libcudnn.so.7.0 \
 /usr/local/lib/libcudnn.so
sudo ldconfig –v
```
