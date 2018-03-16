---
layout: post
title: "docker basic usage"
date: 2018-03-09 22:13:23 +0800
comments: true
categories: [dev]
tags: [docker]
---

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
    "registry-mirrors": ["<your accelerate address>"]

}
EOF
```

restart the docker daemon
```
sudo pkill -SIGHUP dockerd
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### docker registor

$ docker run -d \
  -p 5000:5000 \
  --restart=always \
  --name registry \
  -v /mnt/registry:/var/lib/registry \
  registry:2

http://blog.csdn.net/ronnyjiang/article/details/71189392
https://docs.docker.com/registry/deploying/

### docker tag

`docker tag mxnet-cu80/python:1.1.0-dev mxnet-cu90/python:1.2.0-dev`

### docker save & load

```
docker save -o fedora-all.tar fedora
docker load --input fedora.tar
```

https://docs.docker.com/engine/reference/commandline/save
https://docs.docker.com/engine/reference/commandline/load/#examples
