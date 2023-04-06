---
layout: post
title: Hard Drive Homicide - LD49
category: GameJam
---

<iframe width="750" height="422" src="https://www.youtube.com/embed/559AITYjaO4" title="HDH Game Demo (Vulkan/48hour jam)" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

A top-down shooter where you defeat files shooting bullets back at you. High-Octane, quick levels keep the game difficult and interesting.

The player can collect upgrades and hp as the run progresses, making the character faster, stronger, a better shooter, etc. There is an endless mode for players that want to try and get to harder and harder levels.

<!-- more -->

Made in 48 hours for Ludum-Dare-49

[Source Code on GitHub](https://github.com/NoamZeise/Hard-Drive-Homicide)

I used my [Vulkan framework](https://github.com/NoamZeise/Vulkan-Environment/tree/2D-Environment) for this project, improving on it slightly from my last project by making it cross-platform between linux and windows (although I havent got audio working in Linux yet), using cmake for managing the building, and using a text editor instead of the visual studio IDE i’ve used in all my past projects. I definitely have much to learn in terms of properly structuring my projects and using cmake but I feel this was a nice learning experience.

For the first time I implimented a particle system, which allows a particle to be emitted from a position, having a modifiable direction, speed, start, and end colour. Here are some examples of the use of particles in the game:

#### player death at 25% speed
![particles 1](/assets/img/posts/hard-drive-homicide/gif1.webp)
#### enemy death at 25% speed
![particles 2](/assets/img/posts/hard-drive-homicide/gif2.webp)
#### bullet ricochet at 25% speed
![particles 3](/assets/img/posts/hard-drive-homicide/gif3.webp)

