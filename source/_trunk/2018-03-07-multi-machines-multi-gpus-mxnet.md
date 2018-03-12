---
title: 多机多卡训练mxnet
categories:
  - dev
tags:
  - mxnet
  - deep_leaning
published: false
date: 2018-03-07 11:43:00
---


### Distributed Training with Multiple Machines

- `dist_sync` behaves similarly to `local` but exhibits one major difference. With `dist_sync`, `batch-size` now means the batch size used on each machine. So if there are n machines and we use batch size b, then `dist_sync` behaves like `local` with batch size `n*b`.

- `dist_device_sync` is similar to `dist_sync`. The difference between them is that `dist_device_sync` aggregates gradients and updates weight on GPUs while `dist_sync` does so on CPU memory.

- `dist_async` performs asynchronous updates. The weight is updated whenever gradients are received from any machine. The update is atomic, i.e., no two updates happen on the same weight at the same time. However, the order is not guaranteed.


references
-----------
https://mxnet.apache.org/faq/multi_devices.html?highlight=distributed
