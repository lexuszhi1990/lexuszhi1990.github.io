---
title: setup-gluster-fs-on-ubuntu
date: 2018-10-25 20:24:42
tags:
---

### install gluster

```
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:gluster/glusterfs-5
sudo apt-get update
sudo apt-get install glusterfs-server=5.0-ubuntu1~xenial2 -y
sudo systemctl start glusterd
sudo systemctl enable glusterd
sudo systemctl status glusterd
```

### server ops

add server: `gluster peer probe <server>`

listing servers: `gluster pool list`

view server states: `gluster peer status`

removing servers: `gluster peer detach <server>`

https://docs.gluster.org/en/v3/Administrator%20Guide/Storage%20Pools/#adding-servers

### setup volumes

Create the distributed volume:
```
# gluster volume create test-volume server1:/exp1 server2:/exp2 server3:/exp3 server4:/exp4
Creation of test-volume has been successful
Please start the volume to access data.
```

mount volumes:
`mount -t glusterfs HOSTNAME-OR-IPADDRESS:/VOLNAME MOUNTDIR`

https://docs.gluster.org/en/v3/Administrator%20Guide/Setting%20Up%20Volumes/

### manage volumes

shrink a volume:

```
$ gluster volume remove-brick <VOLNAME> <BRICKNAME> start

$ gluster volume remove-brick <VOLNAME> <BRICKNAME> status

$ gluster volume remove-brick <VOLNAME> <BRICKNAME> commit

$ gluster volume info
```

https://docs.gluster.org/en/v3/Administrator%20Guide/Managing%20Volumes/

### setup disk

```
sudo fdisk /dev/sdc
sudo mkfs.ext4 /dev/sdc1
mkdir -p /apps/gluster-brick1
echo "/dev/sdc1 /apps/gluster-brick1 ext4 defaults 0 0" | sudo tee --append /etc/fstab
sudo mount -a && sudo mount
```

```
sudo gluster peer probe dt-node1
sudo gluster peer probe zs
sudo gluster peer status
```

```
mkdir /apps/gluster-brick1/gv0
mkdir -p /data/gluster-brick1/gv0

sudo gluster volume create gv0 replica 2 zs:/apps/gluster-brick1/gv0 dt-node1:/data/gluster-brick1/gv0

sudo gluster volume create gv0 replica 2 zs:/apps/gluster-brick1/gv0 abc:/apps/gluster-brick1/gv0

sudo gluster volume create gv0 2 zs:/apps/gluster-brick1/gv0 dt-node1:/data/gluster-brick1/gv0
```

### add brick

```
abc@abc:~$ sudo gluster volume add-brick gv0 replica 3 abc:/apps/gluster-brick1/gv0
volume add-brick: success
```

### troubleshot

GlusterFS Error volume add-brick: failed: Pre Validation failed on BRICK is already part of a volume:
```
sudo setfattr -x trusted.gfid /apps/gluster-brick1/gv0
sudo setfattr -x trusted.glusterfs.volume-id /apps/gluster-brick1/gv0
sudo rm -rf /apps/gluster-brick1/gv0/.glusterfs/
```

Brick1: zs:/apps/gluster-brick1/gv0
Brick2: dt-node1:/data/gluster-brick1/gv0
Brick3: abc:/apps/gluster-brick1/gv0

sudo setfattr -x trusted.gfid /apps/gluster-brick1/gv0
sudo setfattr -x trusted.glusterfs.volume-id /apps/gluster-brick1/gv0
sudo rm -rf /apps/gluster-brick1/gv0/.glusterfs/

references:
------------
https://docs.gluster.org/en/v3/
https://docs.gluster.org/en/v3/Install-Guide/Install/#for-ubuntu
https://access.redhat.com/documentation/en-US/Red_Hat_Storage/2.1/html/Administration_Guide/index.html
https://docs.okd.io/latest/install_config/storage_examples/gluster_example.html

