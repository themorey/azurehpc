#!/bin/bash
if ! rpm -q nfs-utils; then
    yum install -y nfs-utils
fi

mountpath=$1
mountpoint=$2

mkdir -p $mountpoint

echo "$mountpath $mountpoint nfs bg,rw,hard,noatime,nolock,rsize=65536,wsize=65536,vers=3,tcp,_netdev 0 0" >>/etc/fstab

mount $mountpoint

chmod 777 $mountpoint
