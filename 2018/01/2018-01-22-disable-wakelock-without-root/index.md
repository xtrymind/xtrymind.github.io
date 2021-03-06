# Disable wakelock without root on Xiaomi Devices

After succesfully configure [BetterBatteryStats](use-bbs-non-root.html), it's time to see what apps that has lots of wakelocks. Open BetterBatteryStats and go over Partial Wakelocks, you will see an apps that have wakelocks there.

Example on my phone, six hour after installing BetterBatteryStats, Twitter apps have a lots of wakelocks for over 4 minutes, we can see it activity is analytics so we can safely disable this wakelocks.

![Imgur](https://i.imgur.com/vadkMvL.png)

open cmd (if you're on windows) or terminal (if you're on linux) and enter adb shell, after that type this command:
```
$ cmd appops set com.android.application WAKE_LOCK ignore
```

for Twitter apps, it should be 
```
$ cmd appops set com.twitter.android WAKE_LOCK ignore
```

after that, all wakelocks requests by the app or in case above Twitter app, will be ignored by the Android system

![Imgur](https://i.imgur.com/EOR9nA8.png)

Source: [XDA](https://www.xda-developers.com/stop-wakelocks-android-without-root/)

