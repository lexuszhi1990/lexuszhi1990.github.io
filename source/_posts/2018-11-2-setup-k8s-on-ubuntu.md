---
title: setup-k8s-on-ubuntu
date: 2018-10-23 14:29:01
comments: true
categories: [dev]
tags: [docker, k8s, deep learning]
---

当前深度学习模型训练中，还往往采用的是单机多卡的方式，如果主机较多的情况下，每个人单独使用固定的一台或几台服务器，GPU利用率不高，而且，训练需要较大的 batch size(如 densenet)，或者需要在短时间内训练完成，则单机多卡有可能不满足需求。
基于kubernetes搭建训练分布式平台，对训练任务容器化，并支持GPU的自动调度。
<!-- more -->

### 当前部署环境

系统版本，ubuntu 16.04:
```
$ uname -a
Linux dt-node1 4.15.0-36-generic #39~16.04.1-Ubuntu SMP Tue Sep 25 08:59:23 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
```
![](/assets/img/ubuntu-info.png)

docker 版本:
```
$ docker version
Client:
 Version:           18.06.1-ce
 API version:       1.38
 Go version:        go1.10.3
 Git commit:        e68fc7a
 Built:             Tue Aug 21 17:24:56 2018
 OS/Arch:           linux/amd64
 Experimental:      false

Server:
 Engine:
  Version:          18.06.1-ce
  API version:      1.38 (minimum version 1.12)
  Go version:       go1.10.3
  Git commit:       e68fc7a
  Built:            Tue Aug 21 17:23:21 2018
  OS/Arch:          linux/amd64
  Experimental:     false
```

### disable firewall

`systemctl disable firewalld && systemctl stop firewalld`

### install bridge

`sudo apt-get install bridge-utils`

### 安装docker

```
apt-cache madison docker-ce
sudo apt-get install docker-ce=18.06.1~ce~3-0~ubuntu
```

### 安装kubernetes准备工作

这里我们采用kubeadm安装k8s，按照[官方文档](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/)即可。唯一需要注意的是k8s默认的image需要手动安装。

#### 安装kubeadm kubelet kubectl

这个也是安装[官方文档](https://kubernetes.io/docs/setup/independent/install-kubeadm/#check-required-ports)即可。这里采用了阿里云的source。直接执行下段命令需要`sudo -i`:

```
apt-get update && apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
```

当前安装的kubeadm版本：
```
$ kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"12", GitVersion:"v1.12.1", GitCommit:"4ed3216f3ec431b140b1d899130a69fc671678f4
", GitTreeState:"clean", BuildDate:"2018-10-05T16:43:08Z", GoVersion:"go1.10.4", Compiler:"gc", Platform:"linux/amd64"}
```

#### 安装 k8s 1.12.1 需要的image

list the basic images used by k8s 1.12.1:
```
$ kubeadm config images list --kubernetes-version=v1.12.1
k8s.gcr.io/kube-apiserver:v1.12.1
k8s.gcr.io/kube-controller-manager:v1.12.1
k8s.gcr.io/kube-scheduler:v1.12.1
k8s.gcr.io/kube-proxy:v1.12.1
k8s.gcr.io/pause:3.1
k8s.gcr.io/etcd:3.2.24
k8s.gcr.io/coredns:1.2.2
```

pull from aliyun and tag:
```
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.12.1
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.12.1
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.12.1
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.12.1
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.2.24
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.2
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1

docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.12.1 k8s.gcr.io/kube-proxy:v1.12.1
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.12.1 k8s.gcr.io/kube-apiserver:v1.12.1
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.12.1 k8s.gcr.io/kube-controller-manager:v1.12.1
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.12.1 k8s.gcr.io/kube-scheduler:v1.12.1
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:3.2.24 k8s.gcr.io/etcd:3.2.24
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:1.2.2 k8s.gcr.io/coredns:1.2.2
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1 k8s.gcr.io/pause:3.1
```

### 安装kubernetes

#### install k8s by kubeadm

cmd:
```
kubeadm init --kubernetes-version=v1.12.1 --pod-network-cidr=10.244.0.0/16
```

outputs:
```
Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join 10.196.50.212:6443 --token qvye1k.iyd56f8kv5n7mgbx --discovery-token-ca-cert-hash sha256:cf2a7146a553384bcba8f33e43920034c67ed22056b7a3a7fa822610e3420659

```

#### Installing a pod network add-on

这里采用`flannel`作为内网网络的插件：
Set `/proc/sys/net/bridge/bridge-nf-call-iptables` to 1 by running `sysctl net.bridge.bridge-nf-call-iptables=1` to pass bridged IPv4 traffic to iptables’ chains.

then install `flannel`:
```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
```

### 添加主机到集群

在`master`安装完成之后，既可以将其他主机加入到集群中，具体的命令如下：
`kubeadm join --token <token> <master-ip>:<master-port> --discovery-token-ca-cert-hash sha256:<hash>`

具体连接[参见](https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#join-nodes):
```
kubeadm join 10.196.50.212:6443 --token t38ktj.cskldrxzvpdkk7ak --discovery-token-ca-cert-hash sha256:338272a82bf284f871584090ce89e3c725e092a67af0e6f4d5b1ed857280977f
```

If you do not have the token, you can get it by running the following command on the master node:
`kubeadm token list`

By default, tokens expire after 24 hours. If you are joining a node to the cluster after the current token has expired, you can create a new token by running the following command on the master node:
`kubeadm token create`

If you don’t have the value of --discovery-token-ca-cert-hash, you can get it by running the following command chain on the master node:
```
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | \
   openssl dgst -sha256 -hex | sed 's/^.* //'
```

### k8s其他配置

#### Master Isolation

By default, your cluster will not schedule pods on the master for security reasons. To disable it:

`kubectl taint nodes --all node-role.kubernetes.io/master-`

output:
```
node "test-01" untainted
taint "node-role.kubernetes.io/master:" not found
taint "node-role.kubernetes.io/master:" not found
```

#### k8s 删除主机

```
kubectl drain --delete-local-data --force --ignore-daemonsets <node name>
kubectl delete node <node name>
```

### 管理GPU

k8s支持NVIDIA和AMD GPU的调度，参见[文档](https://kubernetes.io/docs/tasks/manage-gpus/scheduling-gpus)，

首先需要满足以下条件：

- Kubernetes nodes have to be pre-installed with NVIDIA drivers.
- NVIDIA drivers >= 361.93
- Kubernetes nodes have to be pre-installed with [nvidia-docker 2.0](https://github.com/NVIDIA/nvidia-docker)
- [nvidia-container-runtime](https://github.com/nvidia/nvidia-container-runtime) must be configured as the default runtime for docker instead of runc.

然后安装nvidia官方提供的[k8s插件](https://github.com/NVIDIA/k8s-device-plugin):

```
kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v1.11/nvidia-device-plugin.yml
```

安装完成之后就可以检测到GPU了：
`kubectl describe nodes | grep -B 3 gpu` outputs:

```
$ kubectl describe nodes | grep -B 3 gpu
 hugepages-1Gi:                  0
 hugepages-2Mi:                  0
 memory:                         16367236Ki
 nvidia.com/gpu:                 2
--
 hugepages-1Gi:                  0
 hugepages-2Mi:                  0
 memory:                         16264836Ki
 nvidia.com/gpu:                 2
--
  cpu                            850m (10%)  100m (1%)
  memory                         190Mi (1%)  390Mi (2%)
  attachable-volumes-azure-disk  0           0
  nvidia.com/gpu                 0           0
```

Label your nodes with the accelerator type they have:
`kubectl label nodes <node-with-p100> accelerator=nvidia-tesla-p100`
example:
```
$ kubectl label nodes zs accelerator=nvidia-gtx1080ti
node/zs labeled
$ kubectl label nodes dt-node1 accelerator=nvidia-gtx1080
node/dt-node1 labeled
```

最后就可以在配置文件中申请GPU：

```
apiVersion: v1
kind: Pod
metadata:
  name: gpu-pod
spec:
  containers:
    - name: cuda-container
      image: nvidia/cuda:9.0-devel
      resources:
        limits:
          nvidia.com/gpu: 2 # requesting 2 GPUs
    - name: digits-container
      image: nvidia/digits:6.0
      resources:
        limits:
          nvidia.com/gpu: 2 # requesting 2 GPUs
```

nvidia详细的安装、配置、可视化在k8s gpu的文档
- https://developer.nvidia.com/kubernetes-gpu
- https://docs.nvidia.com/datacenter/kubernetes-install-guide/index.html

### 搭建 k8s dashboard

`dashbaord` 能够有一个前端页面查看、管理当前集群。
![](/assets/img/k8s-dashboard.png)

#### Create certificate(optional)

```
mkdir certs && cd certs/

openssl genrsa -des3 -passout pass:x -out dashboard.pass.key 2048
openssl rsa -passin pass:x -in dashboard.pass.key -out dashboard.key
rm dashboard.pass.key
openssl req -new -key dashboard.key -out dashboard.csr
openssl x509 -req -sha256 -days 365 -in dashboard.csr -signkey dashboard.key -out dashboard.crt
```

lists certs:
```
$ ll
-rw-rw-r-- 1 zs zs 1.1K Oct 24 13:36 dashboard.crt
-rw-rw-r-- 1 zs zs  956 Oct 24 13:36 dashboard.csr
-rw-rw-r-- 1 zs zs 1.7K Oct 24 13:30 dashboard.key
```

generate secret:
```
$ kubectl create secret generic kubernetes-dashboard-certs --from-file=. -n kube-system
secret/kubernetes-dashboard-certs created
```

#### download image

```

docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.11.0
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.11.0 gcr.io/kubernetes-helm/tiller:v2.11.0


docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-state-metrics:v1.2.0
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-state-metrics:v1.2.0 gcr.io/google_containers/kube-state-metrics:v1.2.0

docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/addon-resizer:1.7
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/addon-resizer:1.7 gcr.io/google_containers/addon-resizer:1.7


docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kubernetes-dashboard-amd64:v1.10.0
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kubernetes-dashboard-amd64:v1.10.0 k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.0


docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/heapster-amd64:v1.5.4
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/heapster-amd64:v1.5.4 k8s.gcr.io/heapster-amd64:v1.5.4

docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/heapster-influxdb-amd64:v1.5.2
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/heapster-influxdb-amd64:v1.5.2 k8s.gcr.io/heapster-influxdb-amd64:v1.5.2
```

#### Install kubernetes dashboard service

```
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
```

#### Modify kubernetes dashboard service

change "ClusterIP" to "NodePort":
`kubectl -n kube-system edit service kubernetes-dashboard`

#### Check port on which Dashboard was exposed

```
$ kubectl -n kube-system get service kubernetes-dashboard
NAME                   TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)         AGE
kubernetes-dashboard   NodePort   10.111.48.97   <none>        443:30386/TCP   6m31s
```

#### create user

developer_account.yaml:
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: master-admin
  namespace: kube-system

---

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: master-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: master-admin
  namespace: kube-system
```

```
$ kubectl create -f developer_account.yaml
serviceaccount/master-admin created
clusterrolebinding.rbac.authorization.k8s.io/master-admin created

# zs @ zs in /apps/workspace/certs [14:44:08]
$ kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep master-admin | awk '{print $1}')
Name:         master-admin-token-459v8
Namespace:    kube-system
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: master-admin
              kubernetes.io/service-account.uid: your-uid

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1025 bytes
namespace:  11 bytes
token:      your-token
```

#### dashboard reference

- https://github.com/kubernetes/dashboard
- https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
- https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html
- https://github.com/kubernetes/dashboard/wiki/Creating-sample-user

### troubleshot

#### dnscore 1.2.2 CrashLoopBackOff

```
kube-system   coredns-68fb79bcf6-6s5bp                0/1     CrashLoopBackOff   6          10m
kube-system   coredns-68fb79bcf6-hckxq                0/1     CrashLoopBackOff   6          10m
```

"replacing proxy . /etc/resolv.conf with the ip address of your upstream DNS, for example proxy . 8.8.8.8."
```
kubectl edit cm coredns -n kube-system

kubectl get pods -n kube-system -oname |grep coredns |xargs kubectl delete -n kube-system
```

https://stackoverflow.com/a/52911772
https://coredns.io/plugins/loop/#troubleshooting

#### network: failed to set bridge addr: "cni0" already has an IP address different from 10.244.0.1/24

https://github.com/kubernetes/kubernetes/issues/57280#issuecomment-356431256

```
kubeadm reset
systemctl stop kubelet
systemctl stop docker
rm -rf /var/lib/cni/
rm -rf /var/lib/kubelet/*
rm -rf /etc/cni/
ifconfig cni0 down
ifconfig flannel.1 down
ifconfig docker0 down
ip link delete cni0
ip link delete flannel.1
```

#### The range of valid ports is 30000-32767

https://github.com/kubernetes/kubeadm/issues/122

```
vi /etc/kubernetes/manifests/kube-apiserver.yaml
add `--service-node-port-range=80-32767` then save
systemctl restart kubelet
```

#### 设置 dashboard 登入失效时间

Dashboard的Token失效时间可以通过 token-ttl 参数来设置，修改创建Dashboard的yaml文件，并重新创建即可。

```
kubectl edit deployment kubernetes-dashboard -n kube-system

ports:
- containerPort: 8443
  protocol: TCP
args:
  - --auto-generate-certificates
  - --token-ttl=43200
```

https://github.com/kubernetes/dashboard/issues/2882

#### delete all Evicted pod

`kubectl get pod -n kube-system | grep Evicted | awk '{print $1}'  | xargs kubectl delete pod -n kube-system`


references:
-----------------
- https://kubernetes.io/docs/setup/independent/install-kubeadm/#check-required-ports
- https://unix.stackexchange.com/questions/224156/how-to-safely-turn-off-swap-permanently-and-reclaim-the-space-on-debian-jessie
- https://blog.csdn.net/u010827484/article/details/83025404
- https://www.bookstack.cn/read/learning-kubernetes/installation-kubeadm.md
