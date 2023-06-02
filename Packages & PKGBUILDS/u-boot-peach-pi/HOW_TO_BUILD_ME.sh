#!/bin/bash
#
# Some older versions need Alarm package dtc145 instead of dtc. Wise to change it back after
#
# This and many other versions needs a file patching which is created by the build sytem so can't easily be done at the beginning.
# So we run makepkg twice with slightly different PKGBUILD's and options
#
#If building other versions it's probably better to comment 'cp ../config .config' and uncomment 'make peach-pi_defconfig' in PKGBUILD
#
makepkg -Csf
makepkg -ef -p PKGBUILD2
