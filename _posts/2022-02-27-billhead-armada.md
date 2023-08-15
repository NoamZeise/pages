---
layout: post
title: Billhead Armada - pico-8 shmup for a 24h jam (DSG2022)
category: GameJam
---

<iframe width="750" height="422" src="https://www.youtube.com/embed/sz9dY1JbwRo" title="Billhead Armada Demo" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

<!-- more -->

A shooting game made in 24 hours for the in-person [DuckSauceGames jam 2022](https://www.ducksauce.games/duck-sauce-jam-2022) where it earned 2nd place. 

The game was made using the fantasy console pico-8. Check out the [source code on GitHub](https://github.com/NoamZeise/assorted-pico8-projects/blob/master/billheadArmada/billhead_armada.p8)

The difference between the jam and non jam version is the addition of music by the wonderful [Mick Cooke](https://www.makefiremusic.com/)

It is a bullet hell game with gameplay inspired by the touhou series. I tried to emulate some of the beautiful bullet patterns present in those games.

The movement of the player is such that once you begin moving, you will not come to a stop until you start accelerating in the opposite direction, as it takes place in space. This adds some challenge to the movement as compared to a traditional shmup.

The basic logic for the bullet patterns is similar to my previous experiments in monogame, [seen here](/demo/2020/08/19/Bullet-Hell-Emitter.html). 

I originally had more complicated backgrounds, but due to the restricted size of the screen, I had to make the bullets a single pixel large to really have a bullet-hell experience. Having backgrounds would have negatively impacted visibility, so i opted for a plain background to give the player a better experience.

The game is quite forgiving and you can keep respawning on the same level in the case that you lose all your lives. There are also bombs that clear the screen for when you are in a tight spot. The game has 8 levels, where each level has some lesser enemies that spawn, plus a final boss. There is also a boss rush mode that takes out the lesser enemies. You can also start at any level you want, so that people can try later bosses without having to go through the game each time.

Click on the image below to play the game

<a href="/assets/browser_games/billhead_armada/index.html">
<img src="/assets/img/posts/thumbnails/billhead.png">
</a>
