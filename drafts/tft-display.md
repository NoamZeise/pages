---
layout: post
title: TFT Display
draft: true
---


I'm using a 2 inch 240x320 tft display sold by adafruit driven by an ST7789 controller by Sitronix.

Communication with the display is done via spi, so ensure spi drivers are loaded. 

https://pinout.xyz/

using spi0

pi pin      |  display pin
------------------------
3v or 5v    | V in
ground      | ground
13(gpio 27) | Reset
	15(gpio 22) | D/C (data (high) or command(low) pin)
19          | MOSI (spi data from pi to tft)
23          | spi clock (sck)
24          | CS (spi chip select/enable 0)
