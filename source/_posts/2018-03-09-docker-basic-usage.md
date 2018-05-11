---
layout: post
title: "docker basic usage"
date: 2018-03-09 22:13:23 +0800
comments: true
categories: [dev]
tags: [docker]
---
### install docker

install with official shell file:
```
$ curl -fsSL get.docker.com -o get-docker.sh
$ sudo sh get-docker.sh --mirror Aliyun
```

or you can install docker step by step:
official website: https://docs.docker.com/install/
ubuntu: https://docs.docker.com/install/linux/docker-ce/ubuntu/

### install nvidia docker

https://www.cnblogs.com/dwsun/p/7833580.html
https://github.com/NVIDIA/nvidia-docker

<!-- more -->

Ubuntu:
```
# If you have nvidia-docker 1.0 installed: we need to remove it and all existing GPU containers
docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge -y nvidia-docker

# Add the package repositories
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

# Install nvidia-docker2 and reload the Docker daemon configuration
sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Test nvidia-smi with the latest official CUDA image
docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi
```

### install docker runtime

https://github.com/nvidia/nvidia-container-runtime#installation

`sudo apt-get install nvidia-container-runtime`

add docker nvidia runtime
```
sudo tee /etc/docker/daemon.json <<EOF
{
    "default-runtime": "nvidia",
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
EOF
```

you can set your default registry-mirrors:
"registry-mirrors": ["http://your-aliyun.mirror.aliyuncs.com"]

restart the docker daemon
```
sudo pkill -SIGHUP dockerd
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### docker registor

```
$ docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name registry \
  -v /mnt/registry:/var/lib/registry \
  registry:2
```

http://blog.csdn.net/ronnyjiang/article/details/71189392
https://docs.docker.com/registry/deploying/

### docker rm

We can review the containers on your system with `docker ps`. Adding the `-a` flag will show all containers. When you're sure you want to delete them, you can add the `-q` flag to supply the IDs to the docker stop and docker rm commands:

List all exited containers:
`docker ps -aq -f status=exited`
remove all exited containers:
`docker ps -aq -f status=exited | xargs docker rm`

Remove stopped containers:
`docker ps -aq --no-trunc | xargs docker rm`

Remove containers created after a specific container:
`docker images -q --filter dangling=true | xargs docker rmi`

Remove containers created before a specific container:
`docker ps --before a1bz3768ez7g -q | xargs docker rm`

Use `--rm` together with `docker build` to remove intermediary images during the build process.

```
# Remove unused images
docker image prune

# Remove stopped containers.
docker container prune

# Remove unused volumes
docker volume prune

# Remove unused networks
docker network prune

# Command to run all prunes:
docker system prune
```

### docker tag

`docker tag mxnet-cu80/python:1.1.0-dev mxnet-cu90/python:1.2.0-dev`

### docker save & load

```
docker save busybox > busybox.tar
docker save --output busybox.tar busybox
docker save -o mxnet-ssd-cpu.tar mxnet-ssd-bike:v0.1.1-dev

docker load < mxnet-ssd-cpu.tar
docker load --input mxnet-ssd-cpu.tar
```

https://docs.docker.com/engine/reference/commandline/save
https://docs.docker.com/engine/reference/commandline/load

### docker commit

`docker commit [OPTIONS] CONTAINER [REPOSITORY[:TAG]]`

-a :提交的镜像作者；
-c :使用Dockerfile指令来创建镜像；
-m :提交时的说明文字；
-p :在commit时，将容器暂停。

```
$ docker images mxnet-cu90/python:1.2.0-roialign
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
mxnet-cu90/python   1.2.0-roialign      ff82b60fdcd1        4 days ago          5.36GB

$ docker ps | grep mxnet-cu90
ba77f4f31eae        mxnet-cu90/python:1.2.0-roialign

docker commit -a "lingzhi.me" -m "update python dev" ba77f4f31eae mxnet-cu90/python:1.2.0-roialign

docker images mxnet-cu90/python:1.2.0-roialign
$ docker images mxnet-cu90/python:1.2.0-roialign
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
mxnet-cu90/python   1.2.0-roialign      dce634b0c63f        15 seconds ago      5.38GB
```
