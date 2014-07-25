# AppSync for iOS 7
_iOS 5, 6, and 7+ are supported._

Copyright (c) 2014 Linus Yang, bitst0rm

## Things you need to know first
* __AppSync__ is __NOT__ for piracy.
* __AppSync__ is __for__ _freedom of iOS development with official SDK_.
* __Jailbreak__ is __NOT__ for  piracy.
* __Jailbreak__ is __for__ _freedom of your iOS device_.

Introduction
------------
_AppSync_ is a tool to synchronize your IPA Package freely, especially useful for iOS developers who are not enrolled in the iOS developers' program to test their apps on devices.

Currently, all so-called "AppSync for iOS 7" is made by the notorious Chinese iOS piracy website [25pp.com](http://pro.25pp.com). This 25pp version of AppSync modifies `installd`'s launch daemon plist file for interposing signature checking routines, which is __an ugly workaround__ and __extremely unstable__, causing force close of system apps, or other unexpected behaviours.

On the contrary, the AppSync implementation here ultilizes the dynamic hooking function `MSHookFunction` of Cydia Substrate by @saurik to bypass the signature check, which does not modify any system files and is more generic, stable and safe.

Again, AppSync is __NOT__ meant to support piracy. __Please no piracy and support developers!__

Reference
---------
[com.saurik.iphone.fmil by @saurik](http://svn.saurik.com/repos/menes/trunk/tweaks/fmil/Tweak.mm)

Build
-----
```Bash
git clone --recursive https://github.com/bitst0rm/AppSync.git
cd AppSync
sh build.sh
```

Install Requirements
--------------------
**Mandatory**
* `mobilesubstrate (>= 0.9.5000)`: The package called "_Cydia Substrate_" (formerly "_Mobile Substrate_")

**Optional**
* `UIKit Tools`: Regenerate Spring Board with _uicache_

Troubles Shooting
-----------------
Some users reported a weird issue, some apps icons on the home screen _occasionally_ disappeared after installing apps. It is not clear if the issue is due to the jailbreak or due to a problematic or incompatible jailbreak tweak. It looks like the issue crops up when the `com.apple.mobile.installation.plist` does not load properly.
To fix this, install MobileTerminal or use OpenSSH and run the command:
```Bash
uicache
```
Should reload the `com.apple.mobile.installation.plist` to fix the icons.

Also, you could use the app _Refresh Icons_ to fix the problem in the more convenient way. 
```Bash
https://github.com/bitst0rm/Refresh-Icons
```

Download
--------
You can get the latest precompiled deb from:
```Bash
https://github.com/bitst0rm/AppSync/releases
```

License
-------
Licensed under [GPLv3](http://www.gnu.org/copyleft/gpl.html).
