---
title: helm basic usage
comments: true
categories: [dev]
tags: [docker, helm]
date: 2014-07-07 14:08:18
---

### helm install

snap:
```
sudo snap install helm --classic
snap run helm
```

zip file:
```
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz
tar zxvf helm-v2.11.0-linux-amd64.tar.gz
mv linux-amd64/helm /usr/local/bin/helm
```


gcr.io/kubernetes-helm/tiller:v2.11.0

### helm command

```
helm init --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.11.0 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts

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

```
service:
  type: NodePort
  port: 5432
  externalIPs: []
  ## Manually set NodePort value
  ## Requires service.type: NodePort
  nodePort: 30432

helm del --purge pg
helm install --name pg
```


### kafka

docker pull registry.cn-shanghai.aliyuncs.com/sa_dockerhub/k8szk:v2
docker tag registry.cn-shanghai.aliyuncs.com/sa_dockerhub/k8szk:v2 gcr.io/google_samples/k8szk:v2

docker pull registry.cn-hangzhou.aliyuncs.com/appstore/cp-kafka:4.0.0
docker tag registry.cn-hangzhou.aliyuncs.com/appstore/cp-kafka:4.0.0  confluentinc/cp-kafka:4.0.0


### auth

```
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
```

### prometheus

NOTES:
The Prometheus server can be accessed via port 80 on the following DNS name from within your cluster:
my-prometheus-server.default.svc.cluster.local


Get the Prometheus server URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace default -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace default port-forward $POD_NAME 9090


The Prometheus alertmanager can be accessed via port 80 on the following DNS name from within your cluster:
my-prometheus-alertmanager.default.svc.cluster.local


Get the Alertmanager URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace default -l "app=prometheus,component=alertmanager" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace default port-forward $POD_NAME 9093


The Prometheus PushGateway can be accessed via port 9091 on the following DNS name from within your cluster:
my-prometheus-pushgateway.default.svc.cluster.local


Get the PushGateway URL by running these commands in the same shell:
  export POD_NAME=$(kubectl get pods --namespace default -l "app=prometheus,component=pushgateway" -o jsonpath="{.items[0].metadata.name}")
  kubectl --namespace default port-forward $POD_NAME 9091

For more information on running Prometheus, visit:
https://prometheus.io/



https://yq.aliyun.com/articles/159601
https://help.aliyun.com/document_detail/58587.html
