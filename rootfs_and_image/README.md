The usefulness of this repo is somewhat lessened due to the Arch Arm armv7 repo being a broken mix of old and new packages.  

I've switched to Devuan on my Chromebook.  
But if I release any new kernels they will likely still be Arch packages.  

I might create .debs for some of the other packages like uboot etc. But then again I might not.  



# rootfs and image
### background
It's no secret that the rootfs from [Alarm](https://archlinuxarm.org/platforms/armv7/samsung/samsung-chromebook-2) doesn't work with the Samsung Chromebook 2.  
Well it's a bit of a secret as they've kept pumping out new rootfs's ever since the included kernels stopped working sometime between kernel 5.10 and 5.11 and the instructions on the above link make no mention of the non working kernel ? So semi secret.  
It's likely they haven't realised yet as the [forum thread](https://archlinuxarm.org/forum/viewtopic.php?f=47&t=15169) about the non working kernels is only 5 pages long and easily missed ?   
The usefulness of this repo is somewhat lessened due to the Arch Arm armv7 repo being a broken mix of old and new packages.

I've switched to Devuan on my Chromebook.
But if I release any new kernels they will likely still be Arch packages.

I might create .debs for some of the other packages like uboot etc. But then again I might not.



It seems that whereas before the kernel would load when it had been compiled with multiple dtb's (devicetrees) it now refuses to do so.  
A solution is to compile the kernel with only the peach pi specific dtb  
`make ${MAKEFLAGS} zImage modules exynos5800-peach-pi.dtb`  
as opposed to  
`make ${MAKEFLAGS} zImage modules dtbs`
### Changes made to rootfs and image
The rootfs is the latest from Alarm at the point of writing with the following changes. 
 - Swapped the broken kernel for [this one 6.3.5-1 ](https://github.com/gripped/XE503C32-arch-kernel-packages/tree/main/6.3.5-1/local_modules) with a reduced set of modules. There is a [version](https://github.com/gripped/XE503C32-arch-kernel-packages/tree/main/6.3.5-1/all_modules) with all modules if you want them
 - Swapped linux-firmware with [cb2-firmware](https://github.com/gripped/XE503C32-arch-linux-kernel/tree/main/Packages%20&%20PKGBUILDS/cb2-firmware) which is the firmware extracted from a Peach Pi ChromeOs install. Just install linux-firmware again if you want the full set (see below)
 - Installed a rebuilt vboot-utils package as the one in the Alarm repo doesn't work atm (library mismatch)
 - Added `IgnorePkg = linux-armv7 linux-armv7-chromebook linux-firmware linux-armv7-headers` to /etc/pacman.conf as there's no point upgrading to broken kernels. If you want to upgrade the kernel you'll need to build your own kernel packages, or get them from here if I ever make any, and install with `pacman -U`   
(putting linux-firmware in there was mistake, but I'm not redoing the image for that. Remove it if you need to.) 
### rootsfs
Follow the instructions [here](https://archlinuxarm.org/platforms/armv7/samsung/samsung-chromebook-2).  

Step 7 (optional but fits in with my kernel packages command lines)  
Change the label to `usb_root`  
```
cgpt add -i 2 -t data -b 40960 -s `expr xxxxx - 40960` -l usb_root /dev/sdX
```

Replace step 10 with
```
cd /tmp
curl -LO http://odroidxu.leeharris.me.uk/cb2/ArchLinuxARM-armv7-chromebook-2023-03-01.tar.xz
mkdir root
mount /dev/sdX2 root
bsdtar -xf ArchLinuxARM-armv7-chromebook-2023-03-01.tar.xz -C root
```
Obviously edit sdX to match the device name you are installing to

### Image
If you just want to flash an image containing the both the kernel partition and the root fs to a USB Drive or SD-Card.
```
cd /tmp
curl -LO  http://odroidxu.leeharris.me.uk/cb2/ArchLinuxARM-armv7-chromebook-2023-03-01.img.tar.xz
tar -xvf ArchLinuxARM-armv7-chromebook-2023-03-01.img.tar.xz
dd if=ArchLinuxARM-armv7-chromebook-2023-03-01.img of=/dev/sdX bs=10M status=progress
```
To expand the rootfs patition to use the free space on the device you've installed it to  
`fdisk /dev/sdX`  
You'll see similar to   
> GPT PMBR size mismatch (2097151 != 125045413) will be corrected by
> write. The backup GPT table is not on the end of the device. This
> problem will be corrected by write.  

`w` to write the partition table with fixed sizes then  
```
parted /dev/sdX resizepart 2 100%
e2fsck -f /dev/sdX2
resize2fs /dev/sdX2
```
Read the instructions [here](https://archlinuxarm.org/platforms/armv7/samsung/samsung-chromebook-2) from step 12.  

(Obviously replace sdX with the correct device.   
 If installing to an SD-Card partion numbers are prefixed with a 'p' so for example with /dev/mmcblk1 `e2fsck -f /dev/mmcblk1p2`)  
### Quirks
 - The Peach Pi does not like some USB drives. One I tested the image and rootfs install on (Sandisk Extreme) would beep everytime I first pressed CTRL-U to boot from USB. Pressing CTRL-U a second time successfully booted. This was not an issue with a different USB (Samsung FIT) or the SD-Card I tested it on. So if you get the annoying beep, or it just won't boot at all, try a different USB drive.
 - Logging in as root (password root) sometimes had a long delay and then an invalid pointer error. Seems random ? Logging in as alarm (password alarm) then su to root was a workaround. This seemed to go away once the system had been updated `pacman -Syu`
 - I think the keyboard layout is USA ? Anyway I used `loadkeys uk`for a uk layout. (Just in case you get stuck early on).
