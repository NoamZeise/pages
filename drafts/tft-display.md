---
layout: post
title: TFT Display
draft: true
---


I'm using a 2 inch 240x320 ips tft display sold by adafruit driven by an ST7789 controller by Sitronix.

[ image here ]

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
reboot and check the buff size increased 
with `cat /sys/module/spidev/parameters/bufsiz` you should get `65536`.
Or change the `DISPLAY_TRANSFER_BUFFER_SIZE` 
in `pi_wiring_consts.h` to 4096

The display uses 6 pins but can be wired with 4 minimum.

uses 3 pins for spi (mandatory)
plus 3 gpio pins 
- 22 backlight (optional)
- 24 reset (optional)  
- 25 data / command

The gpio pins used can be changed in `pi_wiring_consts.h`.

For a guide of raspberry pi pins check out https://pinout.xyz/

```
pi             | display
--------------------------
3v or 5v       | V in
ground         | ground
15 (gpio 22)   | Backlight
18 (gpio 24)   | Reset
18 (gpio 25)   | D/C
19 (spi0 mosi) | MOSI
23 (spi0 SCLK) | SCK
24 (spi0 ce0)  | LED CS
```

The adafruit board uses MISO for the sd card, not the display controller,
so none of the ST7789 read commands can be used.

The display supports 12, 16 and 18 bit colour.

```
pixel size | bytes per pixels
---------------------------------
 12 bits   | 3 / 2 4-4-4
 16 bits   | 2 / 1 5-6-5
 18 bits   | 3 / 1 6-xx-6-xx-6-xx
```
   
I went with 16 bit colour by default as 
