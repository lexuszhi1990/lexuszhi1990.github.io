---
title: setup-k8s-on-ubuntu
date: 2018-10-23 14:29:01
tags:
---

### setup env

#### disable firewall

systemctl disable firewalld && systemctl stop firewalld

### install bridge

sudo apt-get install bridge-utils

### 安装docker
```
apt-cache madison docker-ce
sudo apt-get install docker-ce=18.06.1~ce~3-0~ubuntu
```

#### tag basic images for k8s 1.12.1

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

### 安装kubeadm kubelet kubectl
apt-get update && apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl

```
$ kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"12", GitVersion:"v1.12.1", GitCommit:"4ed3216f3ec431b140b1d899130a69fc671678f4
", GitTreeState:"clean", BuildDate:"2018-10-05T16:43:08Z", GoVersion:"go1.10.4", Compiler:"gc", Platform:"linux/amd64"}
```

### install k8s and addons

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

Set `/proc/sys/net/bridge/bridge-nf-call-iptables` to 1 by running `sysctl net.bridge.bridge-nf-call-iptables=1` to pass bridged IPv4 traffic to iptables’ chains.

then install `flannel`:
```
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
```

### Master Isolation

By default, your cluster will not schedule pods on the master for security reasons. To disable it:

`kubectl taint nodes --all node-role.kubernetes.io/master-`

output:
```
node "test-01" untainted
taint "node-role.kubernetes.io/master:" not found
taint "node-role.kubernetes.io/master:" not found
```

### join node

basic comd:
`kubeadm join --token <token> <master-ip>:<master-port> --discovery-token-ca-cert-hash sha256:<hash>`

example:

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

https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#join-nodes

### k8s tear down

https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/#tear-down

```
kubectl drain --delete-local-data --force --ignore-daemonsets <node name>
kubectl delete node <node name>
```

### setup dashboard

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
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kubernetes-dashboard-amd64:v1.10.0
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kubernetes-dashboard-amd64:v1.10.0 k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.0


docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/heapster-amd64:v1.5.4
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/heapster-influxdb-amd64:v1.5.2

docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/heapster-amd64:v1.5.4 k8s.gcr.io/heapster-amd64:v1.5.4
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
              kubernetes.io/service-account.uid: 35576d23-d758-11e8-95d8-6045cb6f3058

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1025 bytes
namespace:  11 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJtYXN0ZXItYWRtaW4tdG9rZW4tNDU5djgiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoibWFzdGVyLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMzU1NzZkMjMtZDc1OC0xMWU4LTk1ZDgtNjA0NWNiNmYzMDU4Iiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOm1hc3Rlci1hZG1pbiJ9.XyP8OtQCCZTGNP6GzXQGwFpFFKP-g7NtckI2yvDq-mp0gjjiAHlJct1Z0i3J8r0hKIqAQr7zfhZu7xcq5QFOsu9-_qcw-tpuhBRTD8A4DOULndaPcSlgHi7k4tRPnt0FqMTwzZMHYSl8bbx8hHg4e2j6Tw72CSDyxUaKTIi8komW3h72ZaOWnyzyx-BkAiav_2AZJ0txXtVh8XNSed39Eko8qUJcXixRFMu0GEp21ipDIiRDPg8iT7_kydFbcfQmWcKhaNk4GmshrgZdlWFH0jN0O3ZZCYwTy602Yeb5bpjVozWU7p2b1tWHxubn7feWkwjwC3xuTuk7EuqjmCdC9g
```

#### reference

https://github.com/kubernetes/dashboard
https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/
https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html

### setup gpu

```
kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v1.11/nvidia-device-plugin.yml
```

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

https://kubernetes.io/docs/tasks/manage-gpus/scheduling-gpus/#deploying-amd-gpu-device-plugin

https://github.com/GoogleCloudPlatform/container-engine-accelerators/blob/master/cmd/nvidia_gpu/README.md

https://github.com/NVIDIA/k8s-device-plugin#preparing-your-gpu-nodes

https://github.com/NVIDIA/nvidia-docker

https://github.com/NVIDIA/nvidia-docker/wiki/Advanced-topics#default-runtime

https://developer.nvidia.com/kubernetes-gpu

https://docs.nvidia.com/datacenter/kubernetes-install-guide/index.html

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

references:
-----------------
https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
https://kubernetes.io/docs/setup/independent/install-kubeadm/#check-required-ports
https://unix.stackexchange.com/questions/224156/how-to-safely-turn-off-swap-permanently-and-reclaim-the-space-on-debian-jessie
https://blog.csdn.net/u010827484/article/details/83025404
https://www.bookstack.cn/read/learning-kubernetes/installation-kubeadm.md
