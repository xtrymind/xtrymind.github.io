# Alternative way to set up python2 for Android Build on Arch Linux


EDIT :
there's dirty trick on arch wiki to fix problem on [venv](https://wiki.archlinux.org/index.php/Android#Setting_up_the_build_environment)

Well, there's not much to write here.

arch linux guide on set up android build tool [here](https://wiki.archlinux.org/index.php/Android#Building_Android) is pretty much detailed on how to do it.
but since android still use python2, and arch use python3 by default, you will have a little problem using python2 with venv.

since it's like that, i'm using this trick to set up python2 :

```
$ sudo mkdir /opt/python2
$ cd /opt/python2
$ sudo ln -s $(which python2) python
```

then put this on build script or paste on current terminal or in .zshrc or .bashrc
```
export PATH="/opt/python2:$PATH"
```
 
source :
 - [Arch Wiki](https://wiki.archlinux.org/index.php/Android)
 - [XDA Developers](https://forum.xda-developers.com/showthread.php?t=2259929)

