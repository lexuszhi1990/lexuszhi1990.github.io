---
title: Ubuntu 14.04 Caffe安装配置(2016/7/5)
categories:
  - dev
  - rails
  - activerecord
  - insert
published: true
date: 2016-07-22 11:43:00
tags:
---


假设已经有一台可以远程连接的GPU服务器，安装了ubuntu14.04的系统。
注1：本安装配置说明难免有所疏漏，请以实际情况为准。
注2：命令请手动输入，多个安装文件请逐个安装确保成功。
注3：环境变量设置是为所有用户设置的方法，如果只对自己设置，请在~/.bashrc下设置。

<!-- more -->

## 安装依赖项软件

`system: Ubuntu 14.04`
安装一些必要的库文件，尤其是新装的系统，在安装运行CUDA SAMPLE时可能会有用。
参考官方说明：http://caffe.berkeleyvision.org/install_apt.html

```sh
sudo apt-get install freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa-dev -y
sudo apt-get install libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler -y
sudo apt-get install --no-install-recommends libboost-all-dev -y
sudo apt-get install libgflags-dev libgoogle-glog-dev liblmdb-dev -y
```

## CUDA安装（.run方法）

下载.run包安装文件和安装手册。接下来只说明一些要点及容易碰到的一些问题，具体参考下面的官方文档，安装过程很详细。
CUDA下载：https://developer.nvidia.com/cuda-downloads
安装文档下载：http://docs.nvidia.com/cuda/#axzz3tmbHqFQn

#### 禁用系统自带nouveau驱动。

```
$ sudo vim /etc/modprobe.d/blacklist-nouveau.conf

	# update blacklist and ptions
	blacklist nouveau
	ptions nouveau modeset=0

$ sudo update-initramfs –u
```

可能需要重新启动,可用下面命令检查是否成功（无输出）。
`$ lsmod | grep nouveau`
注意：tesla-K40等没有独显的机器，在安装完系统可能进入不了图形界面（low-graphic mode），只能进入tty，这时也需要按照上述操作禁用nouveau驱动。

#### 退出图形界面并安装。

关闭和打开图形界面命令：

```sh
sudo stop lightdm
sudo start lightdm
```

安装cuda：
`$ sudo sh cuda_7.0.28_linux.run`

注意：tesla-K40等没有独显的机器，不要选择安装opengl，否则会进入不了界面。

#### 设置环境变量:

#### 如果是单人使用服务器，可以如下配置:

错误：“nvcc: No such file or directory”
	在/etc/environment加入：
> `/usr/local/cuda-7.0/bin`

错误：“error while loading shared libraries: <lib name>: cannot open shared object file: No such file or directory”
在`/etc/ld.so.conf/`新建`cuda.conf`加入：

> `/usr/local/cuda-7.0/lib64`

然后 `$ sudo ldconfig`

#### 如果多人使用服务器，可能会出现所需版本不一致情况，最好还是使用 export 方法, 在`~/.bashrc` 文件中配置:

`export PATH=/your-absolutely-dir/caffe_depends/cuda-7.5/bin:$PATH`

## 安装CUDA SAMPLES并测试。

```
cuda-install-samples-7.0.sh <dir>
sudo make –j8
./deviceQuery
```

## Matlab安装（界面安装，若是不需要，可以跳过）
1.	参考Crack目录下的readme。
sudo ./install
选项：不使用Internet安装
序列号： 12345-67890-12345-67890
默认路径：/usr/local/MATLAB/R2014a
激活文件：license_405329_R2014a.lic
拷贝 libmwservices.so 至 /usr/local/MATLAB/R2014a/bin/glnxa64
`$ sudo cp libmwservices.so /usr/local/MATLAB/R2014a/bin/glnxa64/`

2.	解决编译器gcc/g++版本问题。
因为Ubuntu 14.04的gcc/g++版本是4.8.4，而Matlab 2014a的版本是4.7.x所以在使用matla调用mex文件的时候，基本上都会报错，根据报错信息，考虑暴力引用新版本GLIBCXX_3.4.19。
`$ sudo cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.19
/usr/local/MATLAB/R2014a/sys/os/glnxa64/libstdc++.so.6.0.19`

（libstdc++.so.6.0.19的版本，可能因为系统不同而不同，使用最新的就可以了。）
目录切换到 /usr/local/MATLAB/R2014a/sys/os/glnxa64/ ，非常重要！
```
$ sudo mv libstdc++.so.6 libstdc++.so.6.backup
$ sudo ln -s libstdc++.so.6.0.19 libstdc++.so.6
$ sudo ldconfig -v
```

通过命令“strings /usr/local/MATLAB/R2014a/sys/os/glnxa64/libstdc++.so.6 | grep GLIBCXX_” 可以看一下，是否已经成功包含了GLIBCXX_3.4.19，如果已经存在，基本上就成功了。

## OpenCV安装
1.	使用ouxinyu提供的修改版的安装包 Install-OpenCV-master。
下面的安装方式使用该包完成，安装包修改了dependencies.sh文件并增加了OpenCV 3.0.0的安装文件，同时保留了原来的2.3x和2.4x版。
https://github.com/ouxinyu/Install-OpenCV-master
2.	切换到文件保存的文件夹，然后安装依赖项。
sudo sh Ubuntu/dependencies.sh
注意：ffmpeg可能无法安装成功。

添加ppa：
sudo add-apt-repository ppa:mc3man/trusty-media
sudo apt-get update
sudo apt-get dist-upgrade
具体参考：
https://launchpad.net/~mc3man/+archive/ubuntu/trusty-media
http://askubuntu.com/questions/432542/is-ffmpeg-missing-from-the-official-repositories-in-14-04
3.	切换目录Ubuntu\3.0\安装OpenCV 3.0.0rc1。
sudo sh opencv3_0_0-rc1.sh

## openCV 源码安装

http://blog.aicry.com/ubuntu-14-04-install-opencv-with-cuda/

http://www.cnblogs.com/CarryPotMan/p/5377921.html

https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

https://launchpad.net/~mc3man/+archive/ubuntu/trusty-media

#### INSTALL REQUIRED PACKAGES

```
sudo apt-get update

sudo apt-get install libopencv-dev build-essential checkinstall cmake pkg-config yasm libtiff4-dev libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev python-dev python-numpy libtbb-dev libqt4-dev libgtk2.0-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils

sudo add-apt-repository ppa:mc3man/trusty-media
sudo apt-get update
# DON't Do It!!! sudo apt-get dist-upgrade
sudo apt-get install ffmpeg
sudo apt-get install frei0r-plugins
```

#### CLONE OPENCV'S REPOSITORY

```
mkdir OpenCV
cd OpenCV
git clone https://github.com/Itseez/opencv.git
```

#### BUILD AND INSTALL OPENCV

update the `CMAKE_INSTALL_PREFIX=/usr/local` to your custom dir

```
cd opencv
mkdir release
cd release
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/home/fulingzhi/caffe_depends/opencv-release-3.1 -D WITH_IPP=ON -D WITH_TBB=ON -D WITH_QT=OFF -D WITH_OPENGL=ON -D WITH_V4L=ON -D WITH_CUBLAS=1 -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1  -D BUILD_NEW_PYTHON_SUPPORT=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D INSTALL_CREATE_DISTRIB=ON ..

cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=OFF -D INSTALL_PYTHON_EXAMPLES=OFF -D BUILD_EXAMPLES=OFF -D WITH_QT=OFF -D WITH_OPENGL=ON -D ENABLE_FAST_MATH=1 -D CUDA_FAST_MATH=1 -D WITH_CUBLAS=1 -D CUDA_GENERATION=Kepler ..

make
make install
```

#### CONFIGURE LIBRARY SEARCH PATH

```
echo '/usr/local/lib' | sudo tee -a /etc/ld.so.conf.d/opencv.conf
sudo ldconfig
printf '# OpenCV\nPKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig\nexport PKG_CONFIG_PATH\n' >> ~/.bashrc
source ~/.bashrc
```

查看opencv版本 `pkg-config --modversion opencv`


## python-OpenCV安装

`sudo apt-get install python-opencv`

#### check the installed dir for py-opencv

`dpkg -L python-opencv`

```
/usr/lib/python2.7/dist-packages
/usr/lib/python2.7/dist-packages/cv2.so
/usr/lib/python2.7/dist-packages/cv.py
```

#### add opencv to pythonpath in `~/.bashrc`

`export PYTHONPATH=/usr/lib/python2.7/dist-packages:$PYTHONPATH`

## BLAS安装

ubuntu 14.04直接安装`sudo apt-get install libopenblas-dev` #=> `/usr/lib/libopenblas.so`

openBLAS：https://github.com/xianyi/OpenBLAS/wiki/Installation-Guide

```sh
git clone https://github.com/xianyi/OpenBLAS.git
sudo apt-get install gfortran
sudo make FC=gfortran
sudo make PREFIX=/opt/OpenBLAS install
```

添加环境变量：

1. 在/etc/ld.so.conf.d/openblas.conf 添加/opt/OpenBLAS/lib， 然后 `$ sudo ldconfig`

2. 或者使用用 export 方法
`export LD_LIBRARY_PATH=/opt/OpenBLAS/lib:$LD_LIBRARY_PATH`

## Python环境安装
首先安装pip和python-dev （系统默认有python环境的， 不过我们需要的使python-dev）
sudo apt-get install python-dev python-pip
然后执行如下命令安装（进入CAFFE_ROOT/python/目录）：
for req in $(cat requirements.txt); do sudo pip install $req; done
如果上述命令经常安装失败：
1.	尝试设置一下pip配置（设置国内源）：
vim ~/.pip/pip.conf
[global]
timeout = 6000
index-url = http://pypi.mirrors.ustc.edu.cn/simple/
[install]
use-mirrors = true
mirrors = http://pypi.mirrors.ustc.edu.cn
2.	采用下面命令安装：
一个一个安装，确保都安装成功
sudo apt-get install -y python-numpy python-scipy python-matplotlib python-sklearn python-skimage python-h5py python-protobuf python-leveldb python-networkx python-nose python-pandas python-gflags Cython ipython
sudo apt-get install -y protobuf-c-compiler protobuf-compiler
3.	采用anaconda包（自带大部分环境，推荐）
python anaconda包安装（推荐）
下载Anaconda：
https://www.continuum.io/downloads
bash Anaconda2-2.4.1-Linux-x86_64.sh
如果想使用系统自带的python，在~/.bashrc中将anaconda的环境变量注释掉即可，我们在caffe配置时会直接配置anaconda路径，不影响使用。
jupyter notebook安装
参考安装：http://jupyter.readthedocs.org/en/latest/install.html
	pip install jupyter
也可以参考安装文档使用anaconda安装jupyter。
最常用使用方法：
jupyter-notebook --ip=219.223.*.*
***注意这里是jupyter-notebook***
使用浏览器打开http://219.223.252.218:8888/。

## 安装cuDNN
安装前请去先[官网下载](https://developer.nvidia.com/cudnn)最新的cuDNN。

接然解压文件即可：`$ tar xvf cudnn-7.5-linux-x64-v5.0-ga.tgz`

#### 使用ldconfig方法
sudo cp cudnn.h /usr/local/include
sudo cp libcudnn.so /usr/local/lib
sudo cp libcudnn.so.7.0 /usr/local/lib
sudo cp libcudnn.so.7.0.64 /usr/local/lib
链接cuDNN的库文件。
sudo ln -sf /usr/local/lib/libcudnn.so.7.0.64 \
 /usr/local/lib/libcudnn.so.7.0
sudo ln -sf /usr/local/lib/libcudnn.so.7.0 \
 /usr/local/lib/libcudnn.so
sudo ldconfig –v

#### 使用 export方法

这是 `INSTALL.txt`:

```
LINUX

    cd <installpath>
    export LD_LIBRARY_PATH=`pwd`:$LD_LIBRARY_PATH

    Add <installpath> to your build and link process by adding -I<installpath> to your compile
line and -L<installpath> -lcudnn to your link line.
```

然后修改 `$caffe_root/Makefile.config`:

将安装后的 `cuDNN_INCLUDE` `cuDNN_LIB`目录加到`INCLUDE_DIRS` 和 `LIBRARY_DIRS`中即可：

``` sh
In Makefile.config:
# add cnDNN dirs
cuDNN_INCLUDE := /home/ubuntu/caffe_depends/cudnn-7.5-linux-x64-v2/include
cuDNN_LIB := /home/ubuntu/caffe_depends/cudnn-7.5-linux-x64-v2/lin64

INCLUDE_DIRS := $(PYTHON_INCLUDE) $(cuDNN_INCLUDE) /usr/local/include
LIBRARY_DIRS := $(PYTHON_LIB) $(cnDNN_LIB) /usr/local/lib /usr/lib
```

## 编译运行Caffe

1. 编译caffe-master。
cp Makefile.config.example Makefile.config
具体配置见附录。`-j8`是使用CPU的多核进行编译。
```sh
sudo make all -j8
sudo make test -j8
sudo make runtest -j8
```

2. 编译Python和Matlab用到的caffe文件。
```
sudo make pycaffe
sudo make matcaffe
```

3. 使用MNIST数据集进行测试
3.1 数据预处理。
`sh data/mnist/get_mnist.sh`
3.2	重建lmdb文件。
Caffe支持三种数据格式输入网络，包括Image(.jpg, .png等)，leveldb，lmdb，根据自己需要选择不同输入吧。
sh examples/mnist/create_mnist.sh
生成mnist-train-lmdb 和 mnist-train-lmdb文件夹，这里包含了lmdb格式的数据集。
3.2	训练mnist。
sh examples/mnist/train_lenet.sh
Nvidia K40硬件设置
http://caffe.berkeleyvision.org/performance_hardware.html

## 附录
Makefile.config文件(ubuntu 14.04, cuda 7.5, cudnn 5.0):

References: http://caffe.berkeleyvision.org/installation.html

```sh
## Refer to http://caffe.berkeleyvision.org/installation.html
# Contributions simplifying and improving our build system are welcome!

# cuDNN acceleration switch (uncomment to build with cuDNN).
USE_CUDNN := 1

# CPU-only switch (uncomment to build without GPU support).
# CPU_ONLY := 1

# To customize your choice of compiler, uncomment and set the following.
# N.B. the default for Linux is g++ and the default for OSX is clang++
# CUSTOM_CXX := g++

# CUDA directory contains bin/ and lib/ directories that we need.
# CUDA_DIR := /usr/local/cuda-7.0
CUDA_DIR := /home/fulingzhi/caffe_depends/cuda-7.5
# On Ubuntu 14.04, if cuda tools are installed via
# "sudo apt-get install nvidia-cuda-toolkit" then use this instead:
# CUDA_DIR := /usr

# CUDA architecture setting: going with all of them.
# For CUDA < 6.0, comment the *_50 lines for compatibility.
CUDA_ARCH := -gencode arch=compute_20,code=sm_20 \
		-gencode arch=compute_20,code=sm_21 \
		-gencode arch=compute_30,code=sm_30 \
		-gencode arch=compute_35,code=sm_35 \
		-gencode arch=compute_50,code=sm_50 \
		-gencode arch=compute_50,code=compute_50

# BLAS choice:
# atlas for ATLAS (default)
# mkl for MKL
# open for OpenBlas
BLAS := atlas
# Custom (MKL/ATLAS/OpenBLAS) include and lib directories.
# Leave commented to accept the defaults for your choice of BLAS
# (which should work)!
# BLAS_INCLUDE := /path/to/your/blas
# BLAS_LIB := /path/to/your/blas

# Homebrew puts openblas in a directory that is not on the standard search path
# BLAS_INCLUDE := $(shell brew --prefix openblas)/include
# BLAS_LIB := $(shell brew --prefix openblas)/lib

# This is required only if you will compile the matlab interface.
# MATLAB directory should contain the mex binary in /bin.
# MATLAB_DIR := /usr/local
# MATLAB_DIR := /Applications/MATLAB_R2012b.app

# NOTE: this is required only if you will compile the python interface.
# We need to be able to find Python.h and numpy/arrayobject.h.
PYTHON_INCLUDE := /usr/include/python2.7 \
		/usr/lib/python2.7/dist-packages/numpy/core/include
# Anaconda Python distribution is quite popular. Include path:
# Verify anaconda location, sometimes it's in root.
# ANACONDA_HOME := $(HOME)/anaconda
# PYTHON_INCLUDE := $(ANACONDA_HOME)/include \
		# $(ANACONDA_HOME)/include/python2.7 \
		# $(ANACONDA_HOME)/lib/python2.7/site-packages/numpy/core/include \

# We need to be able to find libpythonX.X.so or .dylib.
PYTHON_LIB := /usr/lib
# PYTHON_LIB := $(ANACONDA_HOME)/lib

# Homebrew installs numpy in a non standard path (keg only)
# PYTHON_INCLUDE += $(dir $(shell python -c 'import numpy.core; print(numpy.core.__file__)'))/include
# PYTHON_LIB += $(shell brew --prefix numpy)/lib

# Uncomment to support layers written in Python (will link against Python libs)
# WITH_PYTHON_LAYER := 1

cuDNN_INCLUDE := /home/fulingzhi/caffe_depends/cudnn/include
cuDNN_LIB := /home/fulingzhi/caffe_depends/cudnn/lib64

# Whatever else you find you need goes here.
INCLUDE_DIRS := $(PYTHON_INCLUDE) $(cuDNN_INCLUDE) /usr/local/include
LIBRARY_DIRS := $(PYTHON_LIB) $(cnDNN_LIB) /usr/local/lib /usr/lib

# If Homebrew is installed at a non standard location (for example your home directory) and you use it for general dependencies
# INCLUDE_DIRS += $(shell brew --prefix)/include
# LIBRARY_DIRS += $(shell brew --prefix)/lib

# Uncomment to use `pkg-config` to specify OpenCV library paths.
# (Usually not necessary -- OpenCV libraries are normally installed in one of the above $LIBRARY_DIRS.)
# USE_PKG_CONFIG := 1

BUILD_DIR := build
DISTRIBUTE_DIR := distribute

# Uncomment for debugging. Does not work on OSX due to https://github.com/BVLC/caffe/issues/171
# DEBUG := 1

# The ID of the GPU that 'make runtest' will use to run unit tests.
TEST_GPUID := 0

# enable pretty build (comment to see full commands)
Q ?= @

```
