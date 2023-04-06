---
layout: post
title: Instance Rendering in Vulkan
category: Demo
---

<iframe width="750" height="422" src="https://www.youtube.com/embed/rG2O6jQz-xc" title="vulkan instance rendering demo - 50,000 meshes , 10,000 unique model/normal matricies" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

A short demo showing 50,000 meshes and 10,000 unique model/normal matricies being drawn at a good frame rate with the Vulkan GPU API. It uses the blinn-phong algorithm for lighting the models.

<!-- more -->

There is a large cpu bottleneck (no cpu multithreading) – most of the time is taken calculating the inverse-transpose matricies for the normal matrix and the rotation matrix for the model.

[Download a windows build](https://github.com/NoamZeise/Vulkan-Environment/files/7699217/instance-rendering-demo.zip)

[Source code on GitHub](https://github.com/NoamZeise/Vulkan-Environment/tree/instance-rendering-demo)

![instance screenshot](/assets/img/posts/instance-rendering/ss1.webp)

you can turn off rotation matricies and normal matrix calculations to see performance differences(for me):

- both off ->full 144 fps (vsync)

- one off -> 80(normal off), 40(rotation off)

- both on -> 30fps

I used a large shader storage buffer of model and normal matricies. This buffer is indexed using 
the instance ID variable that is accessible from the shader if models are drawn using instance rendering.

This program has 5 draw calls, one for each mesh, which each are called with a count of 10,000.

here is another screenshot of the program drawing three different models with more variety of rotations:

![instance screenshot](/assets/img/posts/instance-rendering/ss2.webp)

It gets the exact same framerate as with one model despite having more draw calls because of the cpu bottleneck.
