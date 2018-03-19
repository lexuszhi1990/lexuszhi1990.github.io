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

### docker rm

We can review the containers on your system with `docker ps`. Adding the `-a` flag will show all containers. When you're sure you want to delete them, you can add the `-q` flag to supply the IDs to the docker stop and docker rm commands:

List all exited containers: `docker ps -aq -f status=exited` and remove all exited containers: `docker ps -aq -f status=exited | xargs docker rm`

Remove stopped containers: `docker ps -aq --no-trunc | xargs docker rm`

Remove containers created after a specific container: `docker images -q --filter dangling=true | xargs docker rmi`

Remove containers created before a specific container: `docker ps --before a1bz3768ez7g -q | xargs docker rm`

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
docker save -o fedora-all.tar fedora
docker load --input fedora.tar
```

https://docs.docker.com/engine/reference/commandline/save
https://docs.docker.com/engine/reference/commandline/load/#examples
