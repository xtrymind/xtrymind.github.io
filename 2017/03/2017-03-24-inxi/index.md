# Inxi great cli system informations

There's lot of cli based system information on linux, like neofetch, screenfetch, etc.
inxi is one of those cli based system information, with a lot of options to get all system informations you need
like cpu, machine, bios graphic, network, audio, drives and more.

Since inxi has been moved to aur, you need to build it yourself.
if using aur helper like trizen :
```
$ trizen -S inxi
```
or build it with makepkg
```
$ git clone https://aur.archlinux.org/inxi.git
$ cd inxi
$ makepkg -si
```


first, run this command
```
$ inxi --recommend
```
that command will check application dependencies + recommends, and directories, then shows what package(s) you need to install to add support for that feature

```
$ inxi -b #this command will give you basic output of system informations
 
$ inxi -F #or with inxi -F
 
$ man inxi #run man inxi for detailed informations
```

check [inxi-man](http://smxi.org/docs/inxi-man.htm) if you don't like man pages

![Imgur](https://i.imgur.com/SJeQfjq.png)

