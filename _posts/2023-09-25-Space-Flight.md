---
layout: post
title: Making A 3D Space Sim (GBJam11)
category: GameJam
---

![Screenshot](/assets/img/posts/SpaceFlight/title.png)

## Unfinished Post

This is a 3D flight sim set in a solar system. Lost ship logs litter the system, rewarding exploration. The game uses Vulkan or OpenGL for rendering.

Here I go over a lot of the 3D maths involved in creating a space sim.
This includes getting directions from world space to screen space and 
quaternion rotation for 6DOF ship movement. This is my second 3D game,
and I feel I've learned a lot over the past week.

<!-- more -->

[Here's the source code on GitHub](https://github.com/NoamZeise/gbjam11)

[Download a build on itch](https://noamzeise.itch.io/space-flight)

# Jam Details

GBJam (GameBoy jam) is a week-long game jam with the restriction of having the same resolution as a Gameboy (160×144) and using only 4 colours at once. The game must also use the same input system (dpad + A + B + start + select). 

To illustrate what that looks like when playing on a gameboy, and to show the button layout, here is an image of a gameboy advance playing a gameboy game.

![Pic of Gameboy advance playing a gameboy game](/assets/img/posts/SpaceFlight/gba.jpg)

Because The game is made for playing on the computer, we are affored much more freedom as compared to developing for the original hardware. 
Firstly the   screen is much larger, and secondly we must map the computer's input to the limited input of a gameboy.

The jam itself had a secondary theme of space. I really played into this, making a 3D space flight sim taking place in a large solar system.

# Palettes

The rules of the gamejam allow 4 colours to be used on screen at once, but they don't have to match the actual colours of a Gameboy. The game's palette is the specific colours being used to draw the game. A goal of mine was to implement an easy palette swapping system. This would allow the look of the game to be changed at runtime, and for new palettes to be added without recompiling. Below you can see the results of this, The gif shows some of the game's preloaded palettes with the same scene in the background.

![Palettes swapping gif](/assets/img/posts/SpaceFlight/palettes.gif)

### 2D Vs. 3D

Because of the differences in the shaders for 2D and 3D rendering, I decided to limit the colours of the pipelines in two different ways.

In 2D I limited all of the game's textures to 4 gray-scale colours, I could then render the textures as normal. The current palette is sent to the fragment shader and whichever of the 4 gray shades the fragment is, the colour can be swapped with the corresponding palette colour.

```glsl
int col = int(outColour.r * 100);
switch(col) {
case COLOUR0:
	outColour = palette.col0;
	break;
case COLOUR1:
	outColour = palette.col1;
	break;
case COLOUR2:
	outColour = palette.col2;
	break;
case COLOUR3:
	outColour = palette.col3;
	break;
}
```

![2d palette shading](/assets/img/posts/SpaceFlight/2d-palette-swap.png)

In 3D I didn't want to limit the textures to four colours, and I wanted to use lighting, which usally produces many different shades. The approach I took here was to do everything as normal, then at the end of the fragment shader I calculate the intensity of the final colour. I use the intensity as a threshold value to choose one of the 4 colours from the palette.

```glsl
float intensity = (outColour.x + outColour.y + outColour.z) * 33;
if(intensity < COLOUR0)
	outColour = palette.col0;
else if(intensity < COLOUR1)
	outColour = palette.col1;
else if(intensity < COLOUR2)
	outColour = palette.col2;
else
	outColour = palette.col3;
```

![3d palette shading](/assets/img/posts/SpaceFlight/3d-palette-swap.png)


# Solar System

The planets are shaded using blinn-phong shading, which is then limited to 4 colours.
The source of the light for everything is the sun, which I placed at the origin of the world to make the maths easier.
The planets are a 3D sphere with the model's texture swapped out to make different planets look distinct. Planets also have a custom rotation speed,
so that they slowly spin as you look at them, but the effect can be subtle. See below a very sped up gif of a planet and it's moon spiining.

![spinning planet](/assets/img/posts/SpaceFlight/planet-spin.gif)


# Ship Camera Controls Using Quaternions

Quaternions are mathematical objects that make combining 3D rotations easier.

The ship needed to be able to move along three rotational axes to be realistic. These directions are called pitch, yaw, and roll.

[Pic of pitch, yaw, roll diagram]


 The ship class inherits from my camera class. Previously my cameras have used Euler angles for pitch and yaw, which wouldn't work well with roll too. I needed to use quaternions (which are 4D vectors that help with rotation in 3D) to do pitch, yaw and roll without issues.
 
# Targeting 3D Objects in 2D

The game features a targeting system that makes navigating easier. Targets are shown in 2D with circles around the 3D object. When that object is offscreen, there is an arrow pointing in the direction that will get it onscreen fastest. 
