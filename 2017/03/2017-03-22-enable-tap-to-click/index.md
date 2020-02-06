# Enable tap-to-click

For me, it doesn't feel nice to use touchpad buttons to click something, i'm prefer use touchpad area to click.

you need to install ``libinput`` because ``synaptics`` ( based on Arch Wiki ) is in maintenance mode and is no longer updated.
{% highlight shell %}
$ sudo pacman -S libinput xf86-input-libinput
{% endhighlight %}

add ``30-touchpad.conf`` to ``/etc/X11/xorg.conf.d/:``
{% highlight shell %}
$ sudo vim /etc/X11/xorg.conf.d/30-touchpad.conf
{% endhighlight %}

```conf
Section "InputClass"
	Identifier "touchpad"
	Driver "libinput"
	MatchIsTouchpad "on"
	Option "Tapping" "on"
	Option "Natural Scrolling" "on"
	Option "Accel Speed" "1"
EndSection
```

To enable it in current session without restart:
{% highlight shell %}
$ sudo libinput-list-devices  
$ xinput list-props "your touchpad devices"

#Enable tap-click  
$ xinput set-prop "your touchpad devices" "libinput Tapping Enabled" 1
{% endhighlight %}
beside with ``xorg.conf.d``, you can automatic enabled it on boot by set ``xinput set-prop`` on ``xinitrc`` or autostart program you use.

