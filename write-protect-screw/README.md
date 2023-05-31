# Remove Write Protect
*taken mainly from the excellent https://github.com/hexdump0815/linux-mainline-on-arm-chromebooks*

## Remove the write protect screw
![](https://i.imgur.com/MBU51sS.jpg)
After removing the case screws its seemed to be easier to work with a shim from the rear, monitor end, of the case.
The Chromebook will do a reset when powered on after removing the WP screw. At least mine did.

## Control software write protect
 - Developer mode must be enabled
 - Boot Chromeos, don't log in as normal user
 - CTRL-ALT-F2(→)
 - Login as `chronos` (no password)
 - `sudo su`
```
flashrom --wp-status
flashrom --wp-disable
flashrom --wp-enable
```
## gbb flags
To see them `/usr/share/vboot/bin/get_gbb_flags.sh`
To set them `/usr/share/vboot/bin/set_gbb_flags.sh 0x19`
### the meaning of the flags is (their sum is 0x19):
 - GBB_FLAG_DEV_SCREEN_SHORT_DELAY 0x00000001 - initial boot screen only for 2 seconds instead of the default 30 seconds and no beep afterwards
 - GBB_FLAG_FORCE_DEV_SWITCH_ON 0x00000008 - keep developer mode enabled by default
 - GBB_FLAG_FORCE_DEV_BOOT_USB 0x00000010 - keep the possibility to boot from usb/sd card enabled by default  
 
I wanted to keep the 30 second delay but have FORCE_DEV_SWITCH_ON and FORCE_DEV_BOOT_USB on so used
```
flashrom --wp-disable
/usr/share/vboot/bin/set_gbb_flags.sh 0x18
flashrom --wp-enable
```

It is written in a few places (see hexdump0815 link)  that you can flash an empty boot bitmap (bmpfv) to the firmware to get a black bootup screen. It doesn't seem to work on the Pi. The screen did change. "Developer mode warning" just as text in the centre. But the screen was still bright white. YMMV
