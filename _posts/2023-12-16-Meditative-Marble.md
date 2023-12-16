---
layout: post
title: Meditative Marble (Bigmode Jam 23)
category: gamejam
---

![Meditative Marble Title Image](/assets/img/posts/Meditative-Marble/title.png)

Roll a marble through a grassy landscape. A simulation of ball physics in a procedurally generating continuous world. I used this project to learn about on the fly 3D model generation, accurate 3D collisions, seamless swapping of models, 3rd person cameras, and noise functions.

<!-- more -->

Made in two weeks for [bigmode game jam 2023](https://itch.io/jam/bigmode-2023).

- Check out the [Source Code](https://github.com/NoamZeise/MeditativeMarble)

- Download a [build](https://noamzeise.itch.io/meditative-marble)

This game was made using my 
[graphics rendering library](https://github.com/NoamZeise/Graphics-Environment).
<br>
<br>
<hr>


Here's a high level description of the game before I dive into the techinical details. 

The game describes the map with a function of the form `f(x, y) = z`. 
Using this function I generate a 3D mesh based on the player's position and load it while they are playing. Once the mesh is loaded I swap the current one for the new one so the player sees the world as one continous mesh without noticing the swap.
For the world's shape I use simplex noise of various resolutions combined to create the rolling hills with mountains effect. 

The marble has acceleration, velocity, position and spin to create the illusion of a real ball. The player can add directional acceleration to the ball based on the camera's view. 
The camera follows the player without clipping through the map, pulling back when the player speeds up and pointing in the direction the player moves. 

Below are the details of the above overview.

### AREA UNDER CONSTRUCTION

# 3rd Person Camera

# Generating 3D Models With Code

I wanted to learn about generating meshes with code so my goal was to take an arbitrary surface function and use it to generate a 3d model I could display in the game. 

A surface in 3D is a two dimensional "part" of the space. So we can describe a surface using two parameters. Give a value for each parameter we can output a point in 3d space. By moving through the two parameters we can draw a surface (a graph of this function). If we use a continous (ie no breaks) function we can go through a range of inputs for the two parameters and get out a continous surface in 3D space. This is what I do to generate a mesh for a given function.

The mesh generation code can take any function of the form `f(float, float) = vec3`, as well as the starting and ending points of the two inputs, and a step value for how detailed the mesh should be. You can also specify the uv density, which is how big or small a texture applied to the surface will look.
There is an option to use smooth shading or not. With smooth shading off, vertices at the edges of  triangles are not shared between neighbouring triangles. This give a visible polygon look. 

<div class="container">
	<div class="item">
		<img src="/assets/img/posts/Meditative-Marble/ss-smooth.png">
		<h3> Smooth Shading </h3>
	</div>
	<div class="item">
		<img src="/assets/img/posts/Meditative-Marble/ss-no-smooth.png">
		<h3> Not Smooth Shading </h3>
	</div>
</div>

The structure of the mesh and how it is generated is illustrated well with the image that does 
not use smooth shading. I generate the meshes in a gridlike manner, for each step of each parameter there is a seperate square, which is made of two triangles. With smooth shading there is only one new vertex for each new square 90% of the time, as the other 3 vertices are shared.

To generate a given square of the surface of the function, we determine the 4 verts by either making new ones, or using preexisting ones. To make a vertex we run the surface function on the values of the parameters for that corner, then we assign the vertex position that function's return value. So the square has corners given by `f(a, b), f(a + step_a, b), f(a, b + step_b), f(a + step_a, b + step_b)` for our surface function `f`. Then I calculate the normal from the surface of the triangle for each vertex and add it to the previous normal.

# Collisions with Surface Functions

# Noise Functions

# Loading the World as the Player Moves
