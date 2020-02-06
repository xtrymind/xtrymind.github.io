+++
title = "Epub Thumbnailer"
date = "2018-08-21T05:30:00+07:00"
description = "Generate epub thumbnail on linux"
lastmod = "2018-08-21T13:51:00+07:00"
+++
I have found this [epub thumbnailer](https://github.com/marianosimone/epub-thumbnailer) by chance and immediately fall in love as i have lots of epub on my drive without cover on it and also feel regrets why i didn't meet this script sooner.

To install this script is pretty easy, just run:
```
$ sudo python install.py install
```
in epub-thumbnailer directory and viola, it's done. Supported DE are:

* Gnome
* xfce
* mate
* unity
* openbox
* enlightenment
* i3

if you use archlinux, then use python2
```
$ sudo python2 install.py install
```
and modify `src/epub-thumbnailer.py` to use python2 or you could use arch wiki way [Dealing with version problem in build scripts](https://wiki.archlinux.org/index.php/Python#Dealing_with_version_problem_in_build_scripts). Either way works fine with my machine.
```diff
diff --git a/src/epub-thumbnailer.py b/src/epub-thumbnailer.py
index 93e2eac..5984050 100755
--- a/src/epub-thumbnailer.py
+++ b/src/epub-thumbnailer.py
@@ -1,4 +1,4 @@
-#!/usr/bin/python
+#!/usr/bin/python2
 
 #  This program is free software: you can redistribute it and/or modify
 #  it under the terms of the GNU General Public License as published by
```

Screenshot: 
![Imgur](https://i.imgur.com/VrLvwhf.png)
