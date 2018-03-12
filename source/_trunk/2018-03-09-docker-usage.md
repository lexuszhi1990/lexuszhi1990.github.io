---
layout: post
title: "docker"
date: 2018-03-09 22:13:23 +0800
comments: true
categories: [dev]
---


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
sudo pkill -SIGHUP dockerd


sudo systemctl daemon-reload
sudo systemctl restart docker
