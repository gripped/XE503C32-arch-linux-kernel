# u-boot peach pi
U-boot can be packaged in a kpart image (kernel partition image) so the chomebook boots it as though it were a kernel. Then u-boot is in control of the boot process from that point.  
Using u-boot allows us to boot the the kernel in a more traditional way.  
The advantages of which are:  
 - Easier modification of the kernel command line
 - A menu to be able to easily select different kernels and/or rootfs's
 - The use of an initramfs if one is wanted (required for a usb rootfs atm)  
There's a Arch package [here](https://github.com/gripped/XE503C32-arch-kernel-packages/raw/main/other/u-boot-peach-pi/u-boot-peach-pi-2019.01-1-armv7h.pkg.tar.xz).  
If you want to build it yourself the build files are [here](https://github.com/gripped/XE503C32-arch-kernel-packages/tree/main/other/u-boot-peach-pi)
### Usage
 - It should go without saying but make sure you make a copy of the current kernel partition so you can revert if the below goes wrong
 - Flash /boot/u-boot-peach-pi.kpart to the kernel partion with dd.
 - Copy /boot/extlinux/extlinux.conf.example to /boot/extlinux/extlinux.conf and edit to suit.
 - The partition containing /boot/extlinux/extlinux.conf needs the 'Legacy boot flag' set.  
  `cgpt add -i X -B 1 /dev/mmcblkZ` or   
  `cgpt add -i X -B 1 /dev/sdZ`.   
  Where X is the partition nunber shown by cgpt show /dev/mmcblkZ and Z is the number of     the block device
 - Using a rootfs on an emmc or sdcard does not require an initramfs. Using a rootfs on a usb does seem to need some modules, so an initramfs, unless you build them into the kernel.
 - If you accidently stop u-boot's autoboot `bootd` starts the menu again.
### Other
 - Newer versions do seem to work for autoboot but have issues in the
   u-boot console.
  - 2019.01 was picked as it was the next version after the last ever patch to the peach pi devicetree in the u-boot source.
  - TIMEOUT in extlinux.conf seems to be ignored.
  - btrfs support broke compilation when I tried it but you might have more luck with later versions. Or maybe it just needed some more .config options set ?
  - The only changes I made to the default peach pi config was adding Truetype font support and a bigger font size.
