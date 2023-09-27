---
layout: post
title: Reforestation - 3D Board Game (Raycasting, GMTK2023)
category: GameJam
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/has_7hJQwrI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

My first game in 3D, this was made in 48 hours for GMTK Jam 2023 using my [graphics framework](https://github.com/NoamZeise/Graphics-Environment). I used raycasting to convert from a mouse position to a square on the board that is warped because of the camera's perspective projection.


<!-- more -->

[Check out the souce code on GitHub](https://github.com/NoamZeise/GMTK2023)

[Download a build on itch](https://noamzeise.itch.io/reforestation)

This jam was an opportunity to do a game in 3D to test some of my graphics library's functionality. It was a very different experience to previous games. I had to change the complexity of the game significantly due to time constraints, and could only make a few levels. Overall I'm happy with the result, and look forward to doing more 3D games in the future.

I didn't use any text or audio, so I could remove some of the heavy dependencies of the graphics library (freetype, libsndfile, portaudio). I only used .obj models, so I could build assimp with only one model type. These saves reduced the final size of the game. The game is 2mb, not including the windows C/C++ runtime dlls I package with the game that will already be present on most user's systems. 

# Raycasting

Getting the position on the board that the cursor is hovering over lets us know where place things. To do this we send out an imaginary vector from where the mouse is on the camera. Where this vector would intersect with the plane of the board, is where the mouse is hovering over in 3D. 

We get values for the mouse position between -1 and 1 in the x and y direction, which is called normalised device coordinates(NDC), by corrected for scaling and resolution changes between the rendered scene and the game's window. Using this we can contruct an outward facing vector by adding a Z component of -1. 

```C++
// mouse position on the screen 
// xPos, yPos are within [-1, 1]
vec4 rayClip(xPos, yPos, -1.0f, 1.0f);
```

With the inverse of the game's view and projection matrices we can transform this vector into world space. 

```C++
// using the inverse of the projection matrix gets
// the mouse position in camera space
vec4 rayCam = projInverse * rayClip;
rayCam.z = -1.0f;
rayCam.w = 0.0f;
    
// we can then use the inverse of the view matrix
// to go from camera space to world space
// this means the ray's origin is the camera position.
vec4 rayWorld4 = viewInverse * rayCam;
vec3 rayWorld(rayWorld4.x, rayWorld4.y, rayWorld4.z);
rayWorld = glm::normalize(rayWorld);
```

Now we just need to check at what position the mouse vector would intersect the board. It's facing up at a height of zero, so the normal is `(0, 0, 1)`. We project the mouse vector onto the board's normal using the dot product. 0 here means that these vectors are perpendicular and there are no intersections. Otherwise we can solve for the hit position on the board using the camera's position as the origin of the ray.

```C++
vec3 planeNormal(0.0f, 0.0f, 1.0f); //facing up
float denom = dot(rayWorld, planeNormal);
if(denom != 0) { //ray strikes the plane
	
    // solve for the intersection distance from the ray origin
   	// (camera position) to the plane
	// + 0 is for the distance of the plane along it's normal
	float t = -(dot(cam.getPos(), planeNormal) + 0) / denom; 
		
	// get the hit position by substituting the parameter
	// for the the equation of a ray with t
	vec3 hit = cam.getPos() + rayWorld * t;
	return hit;
}
// return nonsense if the ray is perpendicular to the plane
return vec3(10000.0f);
```

Then it is a simple matter of passing the intersection position to the board
and checking which tile it struck.
