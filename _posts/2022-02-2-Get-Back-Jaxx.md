---
layout: post
title: Get Back Jaxx - Time Travelling Adventure (GGJ2022)
category: GameJam
---

<iframe width="750" height="422" src="https://www.youtube.com/embed/52hGGog31QE" title="GetBackJaxx (GGJ 2022 - 48hr team game jam)" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

A top down zelda-style game about time travel and exploring an abandonded building.

Made in 48 hours For [Global Game Jam 2022](https://globalgamejam.org/2022/games/get-back-jaxx-3), built using my [vulkan framework](https://github.com/NoamZeise/Vulkan-Environment).

This is the first game project in which I worked as a team and it was a very different experience from my solo jams. 

<!-- more -->

[Windows build on itch.io](https://noamzeise.itch.io/get-back-jaxx)

[Source Code on GitHub](https://github.com/NoamZeise/GGJ22)


## Team

[Mick Cooke -> Music](https://www.toomanycookes.co.uk/)

[Wren Weist -> Art](https://www.artstation.com/wrenwiest)

[Retoro -> Sound/Writing](https://www.retrossfx.com/)

Me -> Programming 

# New features

### Tiled map loader

In the lead up to the jam I worked on some necessary additions, this included a loader for maps from a level editor called Tiled. I used rapidXml to parse the xml files which are used by tiled to store the tilemaps. I used a texture offset to specify a section of the texture to use in the shader so that a tileset can be loaded as a single image.

### Camera

I also worked on a 2D camera that keeps within the boundaries of the map. This can be seen in the gameplay video. Camera rects can be specified in the map editor and the camera will stay within that area until the player leaves. A ‘floatiness’ parameter decides how rapidly the camera keeps with the player.

### Animation

I added an Animation class that uses the same type of texture offsets used with the tilemaps to loop through frames of an animation, these can be played at any speed.

### Lighting

Near the end of the jam, once all of the standard logic was in place for the game, I decided to impliment some 2D lighting to make the game more visually impressive.

I specified locations of lights in the tilemap editor, which were loaded into an array of points on the map. Every frame I filled an array of points made up of lights close enough to the camera to have an effect. These were sent to a storage buffer on the GPU that was accessed by my fragment shader. The code below would run on any fragments from draw calls that had lighting enabled.


```glsl
 float attenuation = 0;
 for(int i = 0; i < MAX_LIGHTS; i++)
 {
    if(lighting.lights[i] != vec2(0, 0))
    {
        float distance = length(distance(lighting.lights[i],
                                             gl_FragCoord.xy));
        attenuation += 1.0 / (1.0f + ubo.linear * distance + 
    		       ubo.quadratic * (distance *  distance));  
    }
}

col *= attenuation;
```

I used gl_FragCoord to get the screen coordinate of the pixel, but as the game is dynamically scaled I needed to calculate for each light being sent to the fragment shader it’s screen space coordinate.

The linear and quadratic parameters were sent with a uniform buffer and decide how wide / harsh the lighting is, so the lighting feel can be changed per frame. This is seen in the last part of the game when the player returns to the past and the lighting is far more bright.



![ss1](/assets/img/posts/get-back-jaxx/ss1.webp)
![ss2](/assets/img/posts/get-back-jaxx/ss2.webp)
![ss3](/assets/img/posts/get-back-jaxx/ss3.webp)
![ss4](/assets/img/posts/get-back-jaxx/ss4.webp)
