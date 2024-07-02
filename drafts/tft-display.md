---
layout: post
title: TFT Display
draft: true
---

# Hardware

I have a raspberry pi zero 2 w. This has the same processor as the pi 3,
but only 500mb of ram.

[ image of pi]

I'm using a 2 inch 240x320 ips tft display sold by adafruit driven by an ST7789 controller by Sitronix.

[ image of tft display ]

The info on how to interact with the display, the commands and 
formats it expects, can be found in [the display datasheet](https://www.buydisplay.com/download/ic/ST7789.pdf).
Which was my source of information for writing the code which interacts with the display. 

# Setup

Communication with the display is done via spi, to set up on pi debian:
- ensure spi drivers are loaded 
by adding the following to your `boot/config.txt`
```
dtparam=spi=on
```
- (optional) increase spi buffer size (default is 4096)
by adding the following to your `boot/cmdline.txt` into the single line of settings
```
spidev.buffsiz=65536
```
reboot and check the buff size increased (`cat /sys/module/spidev/parameters/bufsiz`) you should get `65536`.
Alternatively change the `DISPLAY_TRANSFER_BUFFER_SIZE` 
in `pi_wiring_consts.h` to 4096

The display uses 6 pins but can be wired with 4 minimum.
- 3 pins for spi (mandatory)

plus 3 pins:
- 22 backlight pwm(optional)
- 24 reset gpio (optional)
- 25 data / command gpio

The gpio pins can be changed in `pi_wiring_consts.h`.

For a guide of raspberry pi pins check out https://pinout.xyz/

```
pi             | display
--------------------------
3v or 5v       | V in
ground         | ground
32 (gpio 12)   | backlight pwm
18 (gpio 24)   | Reset
18 (gpio 25)   | D/C
19 (spi0 mosi) | MOSI
23 (spi0 SCLK) | SCK
24 (spi0 ce0)  | LED CS
```
Note that the adafruit board uses MISO for the sd card, 
not the display controller.
This means none of the ST7789 read commands can be used. Which is why I skip the MISO pin

[ image of wiring setup ]

## Communicating With the Display

After some experimenting trying to get the monitor to work (This step took a while) I finally had an image on the display.

[ video of lines of colour ]

After some more fiddling, I figured out how to address specific parts of the display properly

[ video of bouncing square ]

I bundled up the code interacting with the monitor into a 
[c api](https://github.com/NoamZeise/pi-graphics/blob/master/src/display.h)
so that I could write programs that used the display.

### Colour Formats

The display supports 12, 16 and 18 bit colour.

```
pixel size | r-g-b bits
-----------------------
 12 bits   | 4-4-4
 16 bits   | 5-6-5
 18 bits   | 8-8-8
```
Where 18 bit only uses the first 6 bits of each byte.

I went with 16 bit colour by default as it is 1.5 times faster than 
18 bit without a big drop in quality.

# Using the Display as a Monitor

My goal is to be able to use the display as if it was a normal hdmi monitor. 
To do this we essentially force the pi to think it is outputting
to a monitor with the same resolution as the tft display, then copy
the framebuffer data over via spi. This allows us to use the 
gpu to render programs as normal without extra effort.

## Terminal tty Display

Reading from `/dev/fb0` one can get the video output for the tty terminal.
This is in the same 16-bit format as the display supports, so we can
just mmap the buffer, and copy it to the display every frame if it
is the correct resolution.

By default the pi will only draw to the framebuffer when a monitor
is plugged in. To get over this we set force hotplug to 1.
We also set the resolution to `320x240` to match the tft.
In the pi config file `/boot/config.txt` I added the following:

```
# force hdmi active
hdmi_force_hotplug=1
# force DMT for hdmi (digital display mode)
hdmi_group=2
# use a custom mode
hdmi_mode=87
# custom mode 
# https://forums.raspberrypi.com/viewtopic.php?f=29&t=24679
hdmi_cvt=320 240 60 1 0 0 0
```

## X11 Display

Next I wanted to be able to see a desktop environment on the display.

With X we can't use the framebuffer directly,
we must request an image of the display from X each frame,
and copy that to the tft.

Also X would always force the wrong resolution
and bit depth. 
To fix this, add a manual config to X11 by creating
```
/etc/X11/10-monitor.conf
```

with contents:

```
Section "Screen"
	Identifier "tft"
	Device "card0"
	DefaultDepth 16
	SubSection "Display"
		Modes "320x240"
	EndSubSection
EndSection
```

Forcing 16 bit depth means we can directy copy X's image buffer
to the display.

libs needed:

libx11-dev
libx extensions

## The Mirroring Program

Using the api I wrote for interacting with the display I built 
a program that mirrors the current display.
It monitors whether the user is in a tty terminal, 
or in a desktop environemnt and switches rendering modes accordingly.

The program is supposed to launch as a systemd service so that it runs
from startup, to make the pi fully usable from the tft-display.

The program spawns two threads. One thread (the renderer) either draws from the framebuffer or from X depending on which draw mode it is in.

The other thread (the manager) is in charge of determining which mode to 
draw in and sleeps most of the time.
If X is not open, it tries to open it. If it succeeds, it checks which
tty X is using with the command
```
ps -e -o tty -o fname | grep Xorg
```
And saves the number.

While X is open the managaer thread checks the active tty at:
```
/sys/class/tty/tty0/active
```
If the active tty 
