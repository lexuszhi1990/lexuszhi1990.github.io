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

