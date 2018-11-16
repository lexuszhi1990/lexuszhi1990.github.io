---
title: prometheus-grafana-on-ubuntu
date: 2018-11-05 14:40:54
comments: true
categories: [dev]
tags: [docker, k8s, prometheus, grafana]
published: false
---

分布式集群的状态监控非常重要，`prometheus + grafana`则是当前比较主流的一种方案。

### 采用 `google/cadvisor`监控docker container状态

```
docker run --rm -v /:/rootfs:ro -v /var/run:/var/run:rw -v /sys:/sys:ro -v /var/lib/docker/:/var/lib/docker:ro -p 8080:8080 --name=cadvisor google/cadvisor:v0.31.0
```

### prometheus

[Prometheus](https://prometheus.io/)是一套开源的监控系统，它将所有信息都存储为时间序列数据；因此实现一种Profiling监控方式，实时分析系统运行的状态、执行时间、调用次数等，以找到系统的热点，为性能优化提供依据。

推荐采用[docker安装](https://prometheus.io/docs/prometheus/latest/installation/)的方法:
```
docker run --rm -p 9091:9090 -v /apps/workspace/fashion-mnist-example/k8s/yaml-py/prometheus.yaml:/etc/prometheus/prometheus.yml prom/prometheus
```

### [grafana](https://grafana.com/)

在官网下载[dashboard](https://grafana.com/dashboards)，并加载进去。

`docker run --rm -p 3000:3000 --name=grafana grafana/grafana`

### install promethues & grafana by helm

从官网获取 prometheus & helm values文件:

```
wget https://raw.githubusercontent.com/helm/charts/master/stable/grafana/values.yaml -o grafana_values.yaml

wget https://raw.githubusercontent.com/helm/charts/master/stable/prometheus/values.yaml -o prometheus_values.yaml
```

安装:
```
helm install --name prometheus stable/prometheus -f prometheus_values.yaml
helm install --name grafana stable/prometheus -f grafana_values.yaml
```

### GPU vis

https://developer.nvidia.com/data-center-gpu-manager-dcgm

docker run --rm --name=nvidia-dcgm-exporter nvidia/dcgm-exporter

helm repo add stable https://burdenbear.github.io/kube-charts-mirror/
helm repo update
helm install coreos/prometheus-operator
helm install cores/kube-prometheus


references
-----------
https://www.cnblogs.com/caizhenghui/p/9184082.html
