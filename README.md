# buildbusybox

Building busybox is done in a script, explaination of the commands goes here:  

## 1. Make a working directory in the home folder  
 
    WORKDIR=$HOME/bbl-3.2  
    mkdir $WORKDIR  

## 2. Download busybox source files and untar:     
    
    cd $WORKDIR  
    curl https://busybox.net/downloads/busybox-1.21.1.tar.bz2 | tar xjf -  

## 3. Make a directory to save all the object files

    cd $WORKDIR/busybox-1.21.1  
    mkdir -pv ../obj/busybox-arm  

## 4. Run make defconfig and menuconfig:  
In menuconfig choose static build option in build options.  

    make O=../obj/busybox-arm ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- defconfig  
    make O=../obj/busybox-arm ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- menuconfig  

## 5. Make install to build busybox for the configuration created:  

    cd $WORKDIR/obj/busybox-arm  
    make ARCH=arm CROSS_COMPILE=arm-none-linux-gnueabi- install  

## 6. Create a directory structure as in linux system:

    mkdir -pv $WORKDIR/initramfs/arm-busybox  
    cd $WORKDIR/initramfs/arm-busybox  
    mkdir -pv {bin,sbin,etc/{init.d},proc,sys,usr/{bin,sbin}}  
    cp -av $WORKDIR/obj/busybox-arm/_install/* .  

## 7. Write a rcS file inside init.d which will be executed after bootup:

    cd etc/init.d/  
    echo -n "#!" >> rcS  
    echo -e "/bin/sh\nmount -t proc none /proc\nmount -t sysfs none /sys\n/sbin/mdev -s" >> rcS  
    chmod +x rcS  

## 8. Create rootfs file  

    cd $WORKDIR/obj/busybox-arm
    find . | cpio -o --format=newc > $WORKDIR/obj/rootfs.img  
    
## 9. Zip rootfs file  

    cd $WORKDIR/obj/  
    gzip -c rootfs.img > rootfs.img.gz  
