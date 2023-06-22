---
layout: post
title: The Last Dodo - Fast Paced Platformer
category: GameJam
---

<iframe width="750" height="422" src="https://www.youtube.com/embed/4F7g-t-fPf0" title="The Last Dodo Polished Demo" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

A game made in 10 days for [GJL Game Parade Spring 2022](https://itch.io/jam/game-parade-spring-2022) built using my [vulkan framework](https://github.com/NoamZeise/Vulkan-Environment). My second time working with a team to make a game. It’s a platforming game where you play as a bird, so the player has a flutter and glide for more movement options. The player must race against the rising water, trying to dodge enemies and bullets, to reach the Dodo nest and lay an egg.

<!-- more -->

We managed to come 11th overall, winning Best Narrative, and getting nominated for Best Itch Page, and Best Use of Audio. 


[Download for Windows or Linux on Itch.io](https://noamzeise.itch.io/the-last-dodo)

[Source Code on GitHub](https://github.com/NoamZeise/DodoDash)


## Team

[Mick Cooke – MakeFire Music   -> Music](https://youtube.com/channel/UCs75GjfGdtTS-CekMJOGICA)

[Thanos Gramosis  -> Art](https://www.artstation.com/tha-com-nos)

Paul James – Wafer Audio -> Sound

Paulina Ramirez –  Lady Yami #3939  -> Voice Over/Writing 

Noam Zeise -> Programming 


# Pre-Polish

This particular game jam had the interesting feature of giving 3 days after the first week of jamming just for polishing the game, no new features. I have footage of the game we uploaded after the first week of jamming:

<iframe width="750" height="422" src="https://www.youtube.com/embed/qNOgMf0cLzA" title="The Last Dodo Demo Video" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

In the polish period I added particle effects for rain and feathers, refined some of the maps and changed the intro/outro a bit. A lot of the art was updated too.

If you want to try the pre-polish version that was finished after 7 days it can be downloaded from the [build link](https://noamzeise.itch.io/the-last-dodo) under “The-Last-Dodo-Week1-Jam”.


# New Framework Features

### Cross platform audio

My previous games using the framework used the windows audio api to play audio. This was not a cross platform solution, so I made a new header to play audio on both Windows and Linux using libsndfile to load audio files and portaudio to play them.

### Rendering To Texture

The framework now renders the app to a texture which is then rendered to the screen in a seperate render pass, this allows the resolution of the game to be different to the final resolution of the screen. This will also allow for post-processing effects in the future.
