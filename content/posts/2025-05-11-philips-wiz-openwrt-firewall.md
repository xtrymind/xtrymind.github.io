+++
title = "Allow Phillips Wiz app to connect to iot zone in openwrt"
date = "2025-05-11T05:42:00+07:00"
description = "Allow philips wiz app to connect to controll iotzone vlan in openwrt"
lastmod = "2025-05-11T05:42:00+07:00"
+++
After setting up vlan on openwrt, and move my philips lamp to iot vlan, i can't controll my lamp if not connected to iot access point. To make it controllable via wiz app in my lan network, we need to set up firewall and open UDP connection port 38899 and 38900 in openwrt firewall trafic rule.

Navigate to Network -> Firwall -> Traffic Rule
Click Add
Source zone set to iot zones, and destination zone set it to lan
on destionation port, set it to 38899 and 38900

![alt](/images/wiz_firewall.png)
