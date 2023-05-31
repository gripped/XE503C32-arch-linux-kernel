# build-kernel  
./build-kernel either builds the latest kernel (from https://github.com/archlinuxarm/PKGBUILDs) or if you add a commit as an argument it will checkout that commit allowing you to build older kernels.  
  
eg if you look here https://github.com/archlinuxarm/PKGBUILDs/commits/master/core/linux-armv7 you can see the kernel versions and commits.  
  
`./build-kernel 9624873`   
(or 962487302106979c09d67b9117ff0106a74704f6)  will build 5.17.0-1  
  
Expect to get asked a few questions about .config. You can either just hit Enter for the default answers or research. I do the former.  
-j4 is added to the kernel make instruction as my chromebook overheats building on all cores for an extended period. YMMV.  
### localmodconfig & localyesconfig  
The file modprobed.db contains the list of modules needed to boot and run the XE503C32 with basic usage.  
If you copy or link this file to 'localmodconfig' (in the same directory) the kernel will be built with with only those modules. Resulting in a much quicker build time and much smaller installed set of modules. However if you plug in, for example, a usb Ethernet adaptor which needs a module it won't work. You'd need to add the needed module to localmodconfig. The same goes for various programs, eg. iptables, which may need modules.  
  
If you copy or link this file to 'localyesconfig' the reduced set of modules will be built into the kernel.  
localyesconfig DOES NOT WORK. I've left it there in case I can figure out why and get it to work. I just get a beep at the initial chromemos screen.
  
Expect to get asked a few more questions about .config  
### kernel partitions produced  
Three kernel partitions will be installed into /boot by the linux-armv7-chromebook package.  
vmlinux.kpart, vmlinux.emmc_root.kpart & vmlinux.usb_root.kpart  
  
vmlinux.kpart has the kernel command line    
`console=tty0 init=/sbin/init root=PARTUUID=%U/PARTNROFF=1 rootwait rw noinitrd`  
This will use as 'root' the squentially next partion from the kernel partition  
This doesn't seem to work when installing onto the emmc. Probably due to the out of order partition layout ?  
  
vmlinux.emmc_root.kpart hasthe kernel command line  
`console=tty0 init=/sbin/init root=PARTLABEL=emmc_root rootwait rw noinitrd`  
This will use as 'root' a partition with the PARTLABEL emmc_root  
PARTLABEL emmc_root can actually be anywhare but there must be only one partition labeled emmc_root  
  
vmlinux.usb_root.kpart has the kernel command line  
`console=tty0 init=/sbin/init root=PARTLABEL=usb_root rootwait rw noinitrd`  
This will use as 'root' a partition with the PARTLABEL usb_root  
PARTLABEL usb_root can actually be anywhare but there must be only one partition labeled usb_root  
  
Use dd to flash the kpart to the the kernel partition  
For example:  
`dd if=/boot/vmlinux.kpart of=/dev/sdX`  
## PARTLABEL  
A PARTLABEL is not the same as a file system label.  
The PARTLABEL cannot be added or changed by any filesystem tools for ext4 btrfs etc.  
  
There are other ways but one sure way to set the PARTLABEL is with cgpt (vboot-utils)  
`cgpt show /dev/sda`  
Find the number of the partition you want under column 'part'.  
and then  
`cgpt add -i XX -l PLABEL /dev/sda`  
Changing XX to the part number and PLABEL to the PARTLABEL you want.  
  
To create a partion for the kernel again you can use cgpt.  
Adapt the instructions [here](https://archlinuxarm.org/platforms/armv7/samsung/samsung-chromebook-2).  
`cgpt add -i 1 -t kernel -b 8192 -s 32768 -l Kernel -S 1 -T 5 -P 10 /dev/sda`  
  
  
