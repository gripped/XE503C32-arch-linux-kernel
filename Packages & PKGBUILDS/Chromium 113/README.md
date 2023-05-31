### Disclaimer

To get this to build I had to switch the standard library to the clang one to get thirdparty/swiftshader to compile. And then back again after.

And there were two files entirely missing from the source. One a compressed js file, the other a compressed html file.
I first had to make a python file in the source ignore them. And later had to create the same empty files with the correct names.
When the program sucessfully linked I was suprised. And even more suprised when it didn't segfault on launch!

If I'm ever daft enough to build this again I'll be more specific about the issues.



[chromium-113.0.5672.126-1-armv7h.pkg.tar.xz](https://github.com/gripped/XE503C32-arch-kernel-packages/blob/main/other/chromium-armv7/chromium-113.0.5672.126-1-armv7h.pkg.tar.xz)
