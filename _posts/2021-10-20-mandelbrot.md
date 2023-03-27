---
layout: post
title: Generating A Mandelbrot BMP with C
category: Demo
---

<img src="/assets/img/posts/mandelbrotwithgrad.webp">

To learn about how images are made and to practice C, I tried writing a program to generate
mandelbrot images and output them as `.bmp` files.

<!-- more -->

[Source Code on github](https://github.com/NoamZeise/bmp-read-write)

I generated an image representing the mandelbrot set by checking each pixel to see if it is a part of it and, if not, I make the pixel darker the faster it blows up to infinity.

[Here is the actual image file(10000×6600)](https://drive.google.com/file/d/1-0XPnFw6Bq2QASeEzgJ0FFdeRILcn6PC/view?usp=sharing)

My program saved it as a bmp, then I converted it to another format to reduce the file size.

Here's the function that generates the pattern:

```C
double inMandelbrot(double x, double y)
{
  double _Complex c = x + (I*y);
  double _Complex z = 0;
  const int iterations = 200;
  const double ratio = 8.0/3.0;
  for(uint i = 0; i < iterations; i++)
  {
    z = (z*z) + c;
    if(cabs(z) > 2)
      return ((double)i / iterations) * ratio;
  }
  if(cabs(z) > 2)
    return 0.0;
  else
    return 1.0;
}
```
