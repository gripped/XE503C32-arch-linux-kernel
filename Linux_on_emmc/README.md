# Linux on the emmc
You don't want to do this unless you have set developer mode and usb boot at the firmware level by disabling [write protect](https://github.com/gripped/XE503C32-arch-linux-kernel/tree/main/write-protect-screw)  
Otherwise at some point
 - The chromebook will run out battery power (It's never fully turned off while the battery has some power)
 - The software flags for dev-mode and usb boot will revert to default
 - The only way to re-enable (AFAICT) dev-mode and usb boot is via chromeos which you've deleted so you'd have to use a recovery USB to reinstall chromeos which wipes everything you had on the emmc

Everything on the emmc can be deleted.  
The following is not a full guide but shows one way to do it assuming you already have a working install on the usb drive your doing it from, and are using my kernel packages. Otherwise adapt as required.

Check device names (they can change)
`fdisk -x`  
`fdisk /dev/mmcblk0`  
`g` new gpt partition table  
`w` write it  
```
cgpt add -i 1 -t kernel -b 8192 -s 32768 -l KERN-A -S 1 -T 5 -P 10 /dev/mmcblk0
cgpt add -i 2 -t kernel -b 40960 -s 32768 -l KERN-B -S 1 -T 5 -P 0 /dev/mmcblk0
cgpt add -i 3 -t data -b 73728 -s `expr  30535647 - 77006` -l emmc_root /dev/mmcblk0
```
The second kernel partion is optional. Note it has priority 0 `-P 0` so won't be used atm but could be useful later if installing various kernels and we want a fallback.
My maths must have been out as I ended up with about 1.6M free at the end of the drive!
```
mkfs.ext4 /dev/mmcblk0p3
mkdir /tmp/emmc
mount PARTLABEL=emmc_root /tmp/emmc
rsync -avxXAHU --exclude=dev/* --exclude=sys/*  --exclude=proc/* --exclude=run/* --exclude=lost+found --delete / /tmp/emmc
cd /boot/
dd if=vmlinux.emmc_root.kpart of=/dev/mmcblk0p1
umount /tmp/emmc
sync
```
