---
title: helm basic usage
comments: true
categories: [dev]
tags: [docker, helm]
date: 2014-07-07 14:08:18
---

### helm install

### helm command

```
helm init --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.8.1 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts

helm list

helm search

helm package

helm install

helm delete
```

example:

```
# http://blog.csdn.net/wenwenxiong/article/details/79075284
helm dep build ./incubator/kafka
helm install -n kafka incubator/kafka
helm del --purge kafka

helm package ./incubator/zookeeper
helm install --name example3 zookeeper-0.4.6.tgz
```

### postgresql

`helm install --name pg stable/postgresql`

NOTES:
PostgreSQL can be accessed via port 5432 on the following DNS name from within your cluster:
pg-postgresql.default.svc.cluster.local

To get your user password run:

    PGPASSWORD=$(kubectl get secret --namespace default pg-postgresql -o jsonpath="{.data.postgres-password}" | base64 --decode; echo)

To connect to your database run the following command (using the env variable from above):

   kubectl run --namespace default pg-postgresql-client --restart=Never --rm --tty -i --image postgres \
   --env "PGPASSWORD=$PGPASSWORD" \
   --command -- psql -U postgres \
   -h pg-postgresql postgres



To connect to your database directly from outside the K8s cluster:
     PGHOST=127.0.0.1
     PGPORT=5432

     # Execute the following commands to route the connection:
     export POD_NAME=$(kubectl get pods --namespace default -l "app=pg-postgresql" -o jsonpath="{.items[0].metadata.name}")
     kubectl port-forward --namespace default $POD_NAME 5432:5432


kubectl run --namespace default pg-postgresql-client --restart=Never --rm --tty -i --image postgres --command /bin/bash


### kafka

docker pull registry.cn-shanghai.aliyuncs.com/sa_dockerhub/k8szk:v2
docker tag registry.cn-shanghai.aliyuncs.com/sa_dockerhub/k8szk:v2 gcr.io/google_samples/k8szk:v2

docker pull registry.cn-hangzhou.aliyuncs.com/appstore/cp-kafka:4.0.0
docker tag registry.cn-hangzhou.aliyuncs.com/appstore/cp-kafka:4.0.0  confluentinc/cp-kafka:4.0.0
