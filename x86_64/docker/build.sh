#!/bin/bash

TAG=latest
if [ ! -z "$1" ];then
	TAG=$1
fi
TMPDIR=openwrt_rootfs
IMG_NAME=geomch/openwrt-x86

[ -d "$TMPDIR" ] && rm -rf "$TMPDIR"
sudo apt-get install pigz
mkdir -p "$TMPDIR"  && \
gzip -dc openwrt-x86-64-default-rootfs.tar.gz | ( cd "$TMPDIR" && tar xf - ) && \
cp -f patches/rc.local "$TMPDIR/etc/" && \
#sed -e 's/\/opt/\/etc/' -i "${TMPDIR}/etc/config/qbittorrent" && \
#sed -e "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" -i "${TMPDIR}/etc/ssh/sshd_config" && \
sss=$(date +%s) && \
ddd=$((sss/86400)) && \
sed -e "s/:0:0:99999:7:::/:${ddd}:0:99999:7:::/" -i "${TMPDIR}/etc/shadow" && \
echo "17 3 * * * /etc/coremark.sh" >> "$TMPDIR/etc/crontabs/root" && \
rm -rf "$TMPDIR/lib/firmware/*" "$TMPDIR/lib/modules/*" && \
(cd "$TMPDIR" && tar cf ../openwrt-x86-64-default-rootfs-patched.tar .) && \
docker build -t ${IMG_NAME}:${TAG} . && \
rm -f  openwrt-x86-64-default-rootfs-patched.tar && \
rm -rf "$TMPDIR" && \
docker save ${IMG_NAME}:${TAG} | pigz -9 > docker-img-openwrt-x86-${TAG}.gz