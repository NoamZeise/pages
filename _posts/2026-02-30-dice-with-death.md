---
layout: post
title: Dice with Death - Duck Sace Jam 2026
category: GameJam
image: /assets/img/posts/thumbnails/dice-with-death.png
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/ttB3pmOMWwI?si=t3aZbf4aQYRErexm" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

The game is based on the Egyptian myth that upon death one's soul would be weighed against a feather by the god Anubis. In this game, your soul is so heavy that Anubis takes pity on you.
By playing hands of dice poker, you can earn extra feathers to help tip the scales in your favour.
This is an endless game where the threshold for your hand score being enough becomes progressively more difficult. 

<!-- more -->

Made in 48 Hours for [Duck Sauce Jam 2026](https://www.ducksauce.games/duck-sauce-jam-2026), with the theme 'Scales', winning 'Best Theme Interpretation'.

[download from itch](https://noamzeise.itch.io/dice-with-death)

[source code](https://github.com/NoamZeise/dice-with-death)

The text rendering for my graphics library is not fully complete, so I intentionally tried to represent the game without text. Many players found this very confusing. Once the rules were clear it seems that people enjoyed it.

## Tools

Made using a framework built on my [Common Lisp graphics library](https://github.com/NoamZeise/gficl). 
Here is the [starter code](https://github.com/NoamZeise/cl-game-template) I used for the project.

## Implementation

The style is heavily inspired by the game Inscryption.
To achieve the look my main goal was to use shadow mapping for the effect of lighting with halftone shading on the shadows. This was an amalgamation of some techniques I had used over the course of my undergraduate dissertation project. I reimplemented shadow mapping, adjusting the parameters to work with a simplified scene and small objects on a table.

The halftone shading is faded in and out based on the distance from the camera. This avoids aliasing for fine grids of dots. The dots themselves are based on the uv coordinates of the object. 

Shadows are calculated as normal, as a value from 0 to 1 for full darkness to full light.
The size of the halftone dots depends on the proportion of the area that is in shadow based on the calculated value. 

Finally I use the metatexture effect seen in my [global game jam submission](/gamejam/2025/01/27/Bubbalah.html) from last year, except the effect is applied to the entire screen instead of being filtered via a stencil. 
