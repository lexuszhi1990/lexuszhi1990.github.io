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



### distributed training codes

```
kv = mx.kvstore.create(kv_store)
if gc_type != 'none':
    kv.set_gradient_compression({'type': gc_type, 'threshold': gc_threshold})

train_iter = DetRecordIter(train_path, batch_size, data_shape, mean_pixels=mean_pixels, label_pad_width=label_pad_width, path_imglist=train_list, kv=kv, **cfg.train)

if kv.rank > 0 and os.path.exists("%s-%d-symbol.json" % (prefix, kv.rank)):
    prefix += "-%d" % (kv.rank)

def save_model(model_prefix, rank=0):
    if model_prefix is None:
        return None
    dst_dir = os.path.dirname(model_prefix)
    if not os.path.isdir(dst_dir):
        os.mkdir(dst_dir)
    return mx.callback.do_checkpoint(model_prefix if rank == 0 else "%s-%d" % (
        model_prefix, rank))
```

### eval metrics

```
i=1
label = labels[0][i].asnumpy()

pred = preds[self.pred_idx][i].asnumpy()
cid = int(pred[0, 0])
indices = np.where(pred[:, 0].astype(int) == cid)[0]

if cid < 0:
    pred = np.delete(pred, indices, axis=0)
    continue

dets = pred[indices]
pred = np.delete(pred, indices, axis=0)
# sort by score, desceding
dets[dets[:,1].argsort()[::-1]]
records = np.hstack((dets[:, 1][:, np.newaxis], np.zeros((dets.shape[0], 1))))

label_indices = np.where(label[:, 0].astype(int) == cid)[0]
gts = label[label_indices, :]
label = np.delete(label, label_indices, axis=0)


xnet.base.MXNetError: [15:11:46] src/operator/nn/./../tensor/../elemwise_op_common.h:123: Check failed: assign(&dattr, (*vec)[i]) Incompatible attr in node  at 0-th output: expected [84,1024,3,3], got [8,1024,3,3]


[name for name in args.keys() if re.compile(r'(.*)_cls_pred_(.*)').match(name)]

args.keys()

exe = net.simple_bind(mx.cpu(), data=(1, 3, 300, 300), label=(1, 1, 5), grad_req='null')

for k in args.keys(): print(k)
if v.shape != args[k].shape:

for k, v in args.items(): print(args[k].shape)
```

references
-----------
https://mxnet.apache.org/faq/multi_devices.html?highlight=distributed
