# Bootloader / boot manager for your arch and windows dualboot installation

I have only test 3 boot manager for my dual boot installation, which is systemd-boot, rEFInd, and GRUB.
My favorite so far is systemd-boot because it's simple and fast but can't use theme :3. 

here command  to install your choice of boot manager for your dual boot installation.
note that systemd-boot and rEFInd not support mbr/bios, only GRUB support mbr/bios

### systemd-boot

```
### install intel-ucode if you use intel proc
$ pacman -S intel-ucode
### Initial ramdisk environment
$ mkinitcpio -p linux
$ bootctl --path=/boot install
```

Then add following content to ``/boot/loader/entries/arch.conf``
```
tittle    Arch
linux     /vmlinuz-linux
initrd    /initramfs-linux.img
initrd    /intel-ucode.img
options   root=PARTUUID=***** rw
```

change entries on ``/boot/loader/loader.conf``
```
timeout 5
default arch
```

More info :[systemd-boot](https://wiki.archlinux.org/index.php/Systemd-boot)

### rEFInd

```
###install intel-ucode if you use intel proc
$ pacman -S intel-ucode refind-efi
### Initial ramdisk environment
$ mkinitcpio -p linux
 
$ refind-install

### refind will find your ESP partitions but in case something wrong, you can manualy pointed your ESP where /dev/sdaXY is your ESP partitions
$ refind-install --usedefault /dev/sdXY
```

to add microcode, edit `/boot/refind_linux.conf `
```
"Boot with standard options" "rw root=UUID=(...) quiet initrd=/boot/intel-ucode.img"
```
More info :[rEFInd](https://wiki.archlinux.org/index.php/REFInd)

### GRUB

```
### install intel-ucode if you use intel proc
$ pacman -S dosfstools grub efibootmgr intel-ucode
$ mkdir /boot/efi
### where /dev/sda2 is your windows ESP partitions
$ mount /dev/sda2 /boot/efi
```

Edit `/etc/default/grub`, set `DEFAULT_TIMEOUT=30`.

```
$ grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub --recheck
$ grub-mkconfig -o boot/grub/grub.cfg
```

Now, let's add Windows to the GRUB menu. Edit `/boot/grub/grub.cfg` and add the following menuentry after the Arch Linux menuentries:

```
menuentry "Windows 10" --class windows --class os {
    insmod part_gpt
    insmod fat
    insmod search_fs_uuid
    insmod chain
    search --fs-uuid --set=root $hints_string $fs_uuid
    chainloader /EFI/Microsoft/Boot/bootmgfw.efi
}
```

where :

`$fs_uuid` by the output of 
```
$ grub-probe --target=fs_uuid /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi
```


`$hints_string`  by the output of
```
$ grub-probe --target=hints_string /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi
```

More info :[GRUB](https://wiki.archlinux.org/index.php/GRUB)

