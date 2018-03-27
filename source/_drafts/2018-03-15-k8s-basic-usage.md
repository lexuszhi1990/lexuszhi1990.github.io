---
layout: post
title: "python basic usages"
date: 2018-03-15 22:13:23 +0800
comments: true
categories: [dev]
tags: [k8s]
---

```
sudo systemctl restart kubelet.service
sudo systemctl restart docker.service
sudo systemctl daemon-reload
```


### troubleshoot

use `kubectl get pod` encouter the errors
```
Reason: Get https://10.254.0.1:443/version: dial tcp 10.254.0.1:443: getsockopt: connection refused
```
use `sudo systemctl daemon-reload`


### minikube install


registry.cn-hangzhou.aliyuncs.com/google_containers/tiller                        v2.8.1              df8896eb004e        6 weeks ago         71.5MB

gcr.io/google-containers/kube-addon-manager                                       v6.5                d166ffa9201a        4 months ago        79.5MB
registry.cn-hangzhou.aliyuncs.com/google_containers/kube-addon-manager-amd64      v6.5                d166ffa9201a        4 months ago        79.5MB
gcr.io/k8s-minikube/storage-provisioner                                           v1.8.1              4689081edb10        4 months ago        80.8MB
registry.cn-hangzhou.aliyuncs.com/google_containers/storage-provisioner           v1.8.1              4689081edb10        4 months ago        80.8MB
k8s.gcr.io/k8s-dns-sidecar-amd64                                                  1.14.5              fed89e8b4248        6 months ago        41.8MB
registry.cn-hangzhou.aliyuncs.com/google_containers/k8s-dns-sidecar-amd64         1.14.5              fed89e8b4248        6 months ago        41.8MB
k8s.gcr.io/k8s-dns-kube-dns-amd64                                                 1.14.5              512cd7425a73        6 months ago        49.4MB
registry.cn-shenzhen.aliyuncs.com/rancher_cn/k8s-dns-kube-dns-amd64               1.14.5              512cd7425a73        6 months ago        49.4MB
k8s.gcr.io/k8s-dns-dnsmasq-nanny-amd64                                            1.14.5              459944ce8cc4        6 months ago        41.4MB
registry.cn-hangzhou.aliyuncs.com/google_containers/k8s-dns-dnsmasq-nanny-amd64   1.14.5              459944ce8cc4        6 months ago        41.4MB
gcr.io/google_samples/k8szk                                                       v2                  2fd25e05d6e2        15 months ago       284MB
registry.cn-shanghai.aliyuncs.com/sa_dockerhub/k8szk                              v2                  2fd25e05d6e2        15 months ago       284MB
registry.cn-hangzhou.aliyuncs.com/google-containers/kube-addon-manager-amd64      v6.1                59e1315aa5ff        16 months ago       59.4MB
gcr.io/google-containers/kube-addon-manager                                       v6.1                59e1315aa5ff        16 months ago       59.4MB

