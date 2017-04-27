WORKDIR=$HOME/bbl-3.2
mkdir $WORKDIR
cd $WORKDIR
curl https://busybox.net/downloads/busybox-1.21.1.tar.bz2 | tar xjf -
cd $WORKDIR/busybox-1.21.1
mkdir -pv ../obj/busybox-arm
make O=../obj/busybox-arm ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- defconfig
make O=../obj/busybox-arm ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- menuconfig
cd $WORKDIR/obj/busybox-arm
make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- install
mkdir -pv $WORKDIR/initramfs/arm-busybox
cd $WORKDIR/initramfs/arm-busybox
mkdir -pv {bin,sbin,etc/{init.d},proc,sys,usr/{bin,sbin}}
cp -av $WORKDIR/obj/busybox-arm/_install/* .
cd etc/init.d/
echo -n "#!" >> rcS
echo -e "/bin/sh\nmount -t proc none /proc\nmount -t sysfs none /sys\n/sbin/mdev -s" >> rcS
chmod +x rcS
cd $WORKDIR/initramfs/arm-busybox
find . | cpio -o --format=newc > $WORKDIR/obj/rootfs.img
cd $WORKDIR/obj/
gzip -c rootfs.img > rootfs.img.gz
echo "done"
