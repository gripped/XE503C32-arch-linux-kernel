# XE503C32-arch-linux-kernel

./build-kernel either builds the latest kernel (from https://github.com/archlinuxarm/PKGBUILDs) or if you add a commit as an argument it will checkout that commit allowing you to build older kernels.

eg if you look here https://github.com/archlinuxarm/PKGBUILDs/commits/master/core/linux-armv7 you can see the kernel versions and commits.

./build-kernel 9624873 (or 962487302106979c09d67b9117ff0106a74704f6)  will build 5.17.0-1.
