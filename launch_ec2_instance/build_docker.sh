#!/bin/sh

cat > Dockerfile << EOT

EOT
docker build --rm --no-cache -t centos-systemd .

docker run --privileged  -itd -e container=docker  -v /sys/fs/cgroup:/sys/fs/cgroup  centos-systemd /usr/sbin/init
# docker run --privileged  --expose=4200 -itd -e container=docker  -v /sys/fs/cgroup:/sys/fs/cgroup  redcricket/fisherman:latest /usr/sbin/init
# docker run --privileged  -p=4200:4200 --expose=4200 -itd -e container=docker  -v /sys/fs/cgroup:/sys/fs/cgroup  redcricket/fisherman:latest /usr/sbin/init
# docker run --privileged  -p=4200:4200 -itd -e container=docker  -v /sys/fs/cgroup:/sys/fs/cgroup  redcricket/fisherman:latest /usr/sbin/init
# docker run --privileged  -p=4200:4200 --expose=4200 -P -itd -e container=docker  -v /sys/fs/cgroup:/sys/fs/cgroup  redcricket/fisherman:latest /usr/sbin/init
