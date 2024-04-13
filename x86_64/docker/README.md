## 支持设备及镜像版本

本项目编译 OpenWrt 镜像，镜像构建完成后将推送到 [DockerHub](https://hub.docker.com/r/geomch/openwrt) 。


### OpenWrt 镜像地址

|  支持设备/平台  |        DockerHub        |
| :-------------: | :---------------------: |
|  x86_64/amd64   | geomch/openwrt-x86:latest |

## 镜像使用方法

1、打开网卡混杂模式，其中enp1s0根据ifconfig命令找到自己的本地网卡名称替换

sudo ip link set enp1s0 promisc on

2、创建名称为macvlan的虚拟网卡，并指定网关gateway、子网网段subnet、虚拟网卡的真实父级网卡parent（第一步中的本地网卡名称）

docker network create -d macvlan --subnet=192.168.123.0/24 --gateway=192.168.123.1 -o parent=enp1s0 macnet

3、查看虚拟网卡是否创建成功，成功的话能看到名称为“macnet”的虚拟网卡

docker network ls

4、拉取镜像，可以通过阿里云镜像提升镜像拉取速度

docker pull geomch/openwrt-x86:latest

5、创建容器并后台运行

docker run -d --name=openwrt --restart always --privileged --network macnet --ip 192.168.123.5 geomch/openwrt-x86:latest

6、进入容器内部环境

docker exec -it openwrt bash

7、根据自己实际情况修改网络配置，修改完成后保存配置

vi /etc/config/network

8、退出容器内部环境，在宿主机环境执行重启容器命令

docker container restart openwrt

### 镜像详细使用方法请参考博客文章:

「在 Docker 中运行 OpenWrt 旁路网关」<https://mlapp.cn/376.html>