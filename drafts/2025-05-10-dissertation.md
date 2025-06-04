---
layout: post
title: 3D Radiance Cascades
image: /assets/img/posts/thumbnails/dissertation.png
---

For my honours project I studied a technique for realistic lighting called radiance cascades, and implemented it to estimate ambient lighting.

Here I will discuss how radiance cascade estimates lighting, discuss by implementation, and go over my main results.

# Radiance Cascades

Radiance cascades was introduced by a Path of Exile developer called Sannikov. The goal is a method for real-time global illumination which does not rely on specialised hardware, such as ray-tracing cores. 

The technique works by tracing rays from probes to sample the lighting conditions for that probe.

The scene is populated with probes of many different resolutions. Low resolution probes capture a small amount of nearby lighting information (low level), whereas high resolution probes capture a larger area of affect, but ignore local lighting conditions (higher levels).

```pic here```

There are far more low resolution probes, but as the level increases, the probe count increases.

# Implementation

I used a framework for graphics experiments I wrote for this project. It is written in Common Lisp and uses OpenGL for rendering.

I begun by naively implementing a grid of probes with set positions in 3D. Although this approach did capture lighting, the implementation was not fast enough for real time. 

I switched to implementing the probes in projection-space. Meaning the probes move with the camera and fill a 2D grid from it's perspective. I later switched this to view-space, as there were interpolation issue, and I needed to get the world-space distance between probes too often.

# RC vs SSAO

In the following screenshots I rendered a scene using both screen-space ambient occlusion and my radiance cascade implementation.

