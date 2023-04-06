---
layout: post
title: 3D Shooter Game - OpenGL
category: Demo
---

<iframe width="750" height="422" src="https://www.youtube.com/embed/3LBfopF_5Ng" title="simple shooter openGL" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

The player can walk around plane with trees and must defeat randomly spawning enemies by shooting at them. The trees spawn randomly and are newly generated as the user walks around. Trees that are too far away are unloaded.

<!-- more -->

[Source Code on GitHub](https://github.com/NoamZeise/simple-OpenGL-shooter-game/releases)

Made in C++ with [OpenGL](https://www.opengl.org/) using custom models and textures and a directional lighting system. I used [GLFW](https://www.glfw.org/) for windowing and [glad](https://glad.dav1d.de/) for openGL function loading, [stb_image](https://github.com/nothings/stb) to import images, and [assimp](https://www.assimp.org/) to deserialize wavefront models.


The game loads models and stores them in a model and mesh class. I first import the models with assimp then transfer the models and meshes into my classes.

I use a directional lighting system, where all models are lit from a single direction. This gives the textures more visiblity and looks a lot nicer than without lighting.

There is a skybox, which is a scaled sphere with a repeating cloud texture. To make the objects coming through the skybox look more natural I use a fog system, where colours are shifted towards the skybox blue colour depending on their distance from the camera.

The game generates chunks which contain a random number of trees with random offsets. The chunks generate as you move around the world. Chunks get deleted when you move too far away from them.

Enemies are spawned after a delay at a random direction from the player. They travel in the direction of the player, and when the enemy and player collide, the chunks are regenerated and all enemies and bullets are removed.

The player can shoot bullets which destroy enemies when they collide with them, the bullets are removed when they are too far away. When the bullets collide with the ground, their y-velocity is reflected.


![ss1](/assets/img/posts/3D-shooter/ss1.webp)
