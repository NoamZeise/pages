---
layout: post
title: 3D Obstalce Avoidance Game - OpenGL
category: Demo
---

<iframe width="750" height="422" src="https://www.youtube.com/embed/v2Yx54FmAoE" title="OpenGl 3D Obstacle Avoidance" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

A simple project for learning the basics of OpenGL. I use a single cube model to represent both the player and the obstacles, the player uses the keyboard to avoid randomly placed and sized obstacles.

<!-- more -->

[download a build of the game for Windows on itch](https://noamzeise.itch.io/3d-obstacle-avoidance)

[source code on GitHub](https://github.com/NoamZeise/3D-Obstacle-Avoidance-OpenGL)

I used GLFW for windowing and glad for openGL functions.


I began learning a little about OpenGL at the beginning of the week. Beforehand I was not too familar with model/view/projection matricies. It was a good experience having to do that manually, as well as using vertex buffer objects to send vertex data to the GPU and vertex array objects to quicky reference the stored verticies. Having to write and apply shaders was also entirely new to me.

I wrote a small shader class to load a vertex and fragment shader from a source file, and link them through a program.

I wrote a shape class which takes vertices as input and stores information such as a reference to the VAO and the amount of triangles a shape needs.

I basically took the logic of my previous SDL2 Project, which was a 2D obstacle avoidance game, and applied it to the 3D realm. The collision detection is still 2D, as objects are stationary on the up/down-axis.
