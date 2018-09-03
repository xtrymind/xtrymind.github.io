+++
title =  "Dualboot archlinux & windows 10 on Asus A46CB"
date =   "2017-03-23T14:20:26+07:00"
author = "Dede Dindin Qudsy"
+++
**Table of Contents**

- [Archlinux on Asus A46CB](#archlinux-on-asus-a46cb)
  - [Before](#before)
  - [Partitioning](#partitioning)
    - [Format and mount disks](#format-and-mount-disks)
  - [Install base system](#install-base-system)
  - [Configure base system](#configure-base-system)
	- [Chroot](#chroot)
	- [Bootloader](#bootloader)
	- [Network](#network)
	- [Reboot](#reboot)
  - [After installation](#after-installation)
	- [Connect to the internet](#connect-to-the-internet)
	- [User Management](#user-management)
	- [Arch User Repository](#arch-user-repository)
	- [Mirror](#mirror)
	- [Graphics](#graphics)
	  - [Driver](#driver)
	  - [Xorg](#xorg)
	  - [Bumblebee](#bumblebee)
	- [Terminal](#terminal)
	- [Touchpad](#touchpad)
	- [Sound](#sound)
	- [Hard Drive](#disk)
	  - [SSD](#ssd)
	  - [HDAPSD](#hdapsd)
	
# Archlinux on Asus A46CB
### Before

1. Disable Windows Fast-Startup
2. Disable Secure Boot

### Partitioning
an example of Windows 10 Efi partitioning on 120GB SSD

| Partition  | Location | Size       | File system |
| ---------- |:--------:|:----------:|:-----------:|
| Recovery   | sda1     | 450 MB     | ntfs        |
| ESP        | sda2     | 100 MB     | vfat        |
| Reserved   | sda3     | 16 MB      | ?           |
| Windows 10 | sda4     | 53 GB      | ntfs        |
| Arch       | sda5     | 58 GB      | ext4        |

#### Format and mount disks

```shell
# mkfs.ext4 /dev/sda5
# mount /dev/sda5 /mnt
# mkdir /mnt/boot
# mount /dev/sda2 /mnt/boot
```
### Install base system

```shell
# wifi-menu
# ping  -c 3 www.google.com #check connections
```

install system and generate fstab

```shell
# pacstrap /mnt base base-devel zsh vim #install base base development zsh and vim to /mnt 
# genfstab -U /mnt >> /mnt/etc/fstab #generate new fstab
```


### Configure base system
#### Chroot
```shell
# arch-chroot /mnt #enter chroot

# passwd #password for root

# ln -sf /usr/share/zoneinfo/Asia/Jakarta /etc/localtime #timezone
# hwclock --systohc #Hardware clock


# vim /etc/locale.gen #uncomment `en_US.UTF-8`
# locale-gen #generate locale
# echo LANG=en_US.UTF-8 > /etc/locale.conf
# export LANG=en_US.UTF-8


# echo arch > /etc/hostname #Hostname
```
```
# edit /etc/hosts
127.0.0.1   localhost.localdomain   localhost
::1         localhost.localdomain   localhost
127.0.1.1   arch.localdomain        arch
```

#### Bootloader
```shell
# pacman -S intel-ucode #install intel ucode if you have intel processor

# mkinitcpio -p linux #Initial ramdisk environment

# bootctl --path=/boot install #install bootloader, using systemd-boot

# blkid -s PARTUUID -o value /dev/sdxY #check partuuid of / partition
```

```
# Then add following content to /boot/loader/entries/arch.conf
tittle    Arch
linux     /vmlinuz-linux
initrd    /initramfs-linux.img
initrd    /intel-ucode.img
options   root=PARTUUID=xxxxx-xxx-xx rw scsi_mod.use_blk_mq=1
```
```
# change entries on /boot/loader/loader.conf
timeout 5
default arch
```

#### Network
Network configuration (Wi-Fi)
```shell
# pacman -S wpa_supplicant networkmanager dialog
# systemctl enable NetworkManager
```
Asus A46CB use Qualcomm Atheros AR9485 as Wi-Fi chipset, in my experience, if you connect to public wi-fi which you need to login first on web, you will get some random disconnect and decrease bandwidth, to resolve just add `options ath9k nohwcrypt=1` to `/etc/modprobe.d/ath9k.conf`
```shell
# echo options ath9k nohwcrypt=1 >> /etc/modprobe.d/ath9k.conf 
```
#### Reboot
```shell
# exit
# umount -R /mnt
# reboot
```

### After installation

#### Connect to the internet
```shell
# nmtui
# ping google.co.id
```

#### User Management
```shell
# useradd -m -G wheel,users -s /bin/zsh xtrymind #add user
# passwd xtrymind

# EDITOR=vim visudo #enable sudo for users
```
```ini
# Uncomment this line in vim:
%wheel ALL=(ALL) ALL
```

#### Mirror
best mirror
```shell
$ sudo pacman -S reflector
$ sudo reflector --latest 200 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist
```
enable 32bit support
```ini
# In `/etc/pacman.conf`, uncomment:
[multilib]
Include = /etc/pacman.d/mirrorlist
```
```shell
$ sudo pacman -Sy
```

#### Display

#### Driver
```shell
$ sudo pacman -S nvidia mesa xf86-video-intel
```

#### Xorg
```shell
$ sudo pacman -S xorg xorg-apps xorg-xinit xbindkeys
```

#### Bumblebee
```shell
$ sudo pacman -S bbswitch bumblebee
$ sudo gpasswd -a xtrymind bumblebee
$ sudo systemctl enable bumblebeed
```

After rebooting, you should see that bbswitch has disabled the card, which is good for saving the battery on the laptop
```shell
$ cat /proc/acpi/bbswitch
0000:01:00.0 OFF
```

#### WM
install i3 as window manager
```shell
$ sudo pacman -S i3
$ cp /etc/X11/xinit/xinitrc ~/.xinitrc #copy xinit to home dirrectory
```
```ini
# open .xinitrc and delete started from twm & to exec xterm and add
exec i3
```

#### Terminal
rxvt-unicode or urxvt is a nice terminal emulator, it's small and fast but a little complicated to configure
```shell
$ sudo pacman -S rxvt-unicode urxvt-perls
```

check [arch wiki](https://wiki.archlinux.org/index.php/Rxvt-unicode) for more detail on how to configure urxvt.

#### Touchpad
install libinput because xf86-input-synaptics ( based on Arch Wiki ) is in maintenance mode and is no longer updated.
```shell
$ sudo pacman -S libinput xf86-input-libinput
```

add ``30-touchpad.conf`` to ``/etc/X11/xorg.conf.d/:``
```shell
$ sudo vim /etc/X11/xorg.conf.d/30-touchpad.conf
```

```
Section "InputClass"
	Identifier "touchpad"
	Driver "libinput"
	MatchIsTouchpad "on"
	Option "Tapping" "on"
	Option "Natural Scrolling" "on"
	Option "Accel Speed" "0.5"
EndSection
```

#### Power Management
#### Powertop
install it by command
```shell
$ sudo pacman -S powertop
```
and add systemd service, create ``/etc/systemd/system/powertop.service```
```
[Unit]
Description=Powertop tunings

[Service]
Type=oneshot
ExecStart=/usr/bin/powertop --auto-tune

[Install]
WantedBy=multi-user.target
```
then enable it
```shell
$ sudo systemctl enable powertop.service
```

#### Laptop Mode
see this [kernel documentation](https://www.kernel.org/doc/Documentation/laptops/laptop-mode.txt) about laptop mode, it help minimize the time that the hard disk needs to be spun up, to conserve battery power on laptops.

create ``/etc/sysctl.d/laptop.conf``
and add :
```
vm.laptop_mode = 5
```

#### Disable Bluetooth
As my AC46CB uses ar9485 as wifi+bluetooth module, i always get error on dmesg caused by crappy ar9485 chipset mainly bluetooth module.
```shell
$ [ 3499.880081] usb 2-3: device descriptor read/64, error -110
$ [ 3515.096081] usb 2-3: device descriptor read/64, error -110
```
to disable it make `/etc/modprobe.d/bluetooth.conf`
```
# disable bluetooth
blacklist btusb bluetooth
install btusb /bin/false
install bluetooth /bin/false
```

#### Backlight

The display’s backlight is a huge power drain, and it is often convenient to have a hotkey to adjust it.

```shell
$ sudo pacman -S xorg-backlight
```
add ``20-intel.conf`` to ``/etc/X11/xorg.conf.d/:``
```shell
$ sudo vim /etc/X11/xorg.conf.d/20-intel.conf
```
```
Section "Device"
	Identifier  "Intel Graphics"
	Driver      "intel"
	Option      "DRI" "2"             # DRI3 is now default
	Option 		"TearFree" "true"
	#Option      "AccelMethod"  "sna" # default
	#Option      "AccelMethod"  "uxa" # fallback
EndSection
```
Now, add commands to xbindkeys for manipulating the backlight:

```
# Backlight Inc
"/usr/bin/xbacklight -inc 5"
    m:0x0 + c:233
    XF86MonBrightnessUp

# Backligth Dec
"/usr/bin/xbacklight -dec 5"
    m:0x0 + c:232
    XF86MonBrightnessDown
```

#### Sound

Just install ``alsa-utils``, and use ``alsamixer`` to unmute the master channel. Should just work.

For keyboard hotkeys, add the following to ``xbindkeys`` configuration:
```
# Volume Up
"/usr/bin/amixer set Master 5%+"
   m:0x0 + c:123
   XF86AudioRaiseVolume

# VOlume Down
"/usr/bin/amixer set Master 5%-"
   m:0x0 + c:122
   XF86AudioLowerVolume

# Mute
"/usr/bin/amixer set Master toggle"
   m:0x0 + c:121
   XF86AudioMute
```
#### Disk
#### SSD
Enable trim support
```shell
$ sudo systemctl enable fstrim.timer
```
#### HDAPSD

Protects your hard drive from sudden shocks

```shell
$ sudo pacman -S hdapsd
$ sudo systemctl enable hdapsd
```

### Performance
#### Input/output schedulers
Reference [Arch Wiki](https://wiki.archlinux.org/index.php/Improving_performance#Input.2Foutput_schedulers)

Enable `scsi_mod.use_blk_mq=1` to kernel parameters to enable block multi-queue (blk-mq) mode.

Add io scheduler rules to udev
```shell
$ /etc/udev/rules.d/60-ioschedulers.rules
```
Set ssd with deadline and hdd to bfq
```
# set scheduler for non-rotating disks
ACTION=="add|change", KERNEL=="sd[a-z]|mmcblk[0-9]*|nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
# set scheduler for rotating disks
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
```
