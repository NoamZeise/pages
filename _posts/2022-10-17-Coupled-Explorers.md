---
layout: post
title: Coupled Explorers - LD51
category: GameJam 
---

<iframe width="750" height="422" src="https://www.youtube.com/embed/mZpsVEkPHo8" title="Coupled Exploreres Demo (LD51)" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

A short physics platformer made in 48 hours for Ludum Dare 51. Two characters share one mind and swap between the bodies every 10 seconds. You must get through each level, making sure that the other character is able to complete the level too. I used this jam as a learning experience, as this was my first time using Rust (and SDL2) for a game jam. 

<!-- more -->

[Download a build for Linux or Windows on Itch.io](https://noamzeise.itch.io/coupled-explorers)

[Source Code on GitHub](https://github.com/NoamZeise/Coupled-Explorers-LD51)


This game had the theme of “Every 10 Seconds”, and I took from the prompt the idea of having two different characters being switched every 10 seconds. My idea to make this interesting would be that the actions you take as one character limit the actions you can take with another. To achieve this I centred the game on a platformer with a lot of platforms that are ‘used up’ by one of the characters, so the other finds it more difficult to traverse the level.

I used some preexisting rust libraries for handling sdl2 resources and draw calls, which I developed for my last rust sdl project (ZL001). I also used a tiled loading libarary I have been working on as part of my sdl2 game template. This tiled loading library, unlike my previous c++ tiled library, is much more thorough in deserializing the map format into a struct. For example I used Tiled’s built in parallax modifiers to change that parallax ratio of the background layers, which I then used to impliment the paralax effect with the visual representation of the map.

Most of the time was spent writing the Phys trait that could be implimented by anything to become a physics object in the game. I could then pass a list of objects that impliment this trait to a physics updating function. This made it much easier to add different blocks in the game, like the ones that fall when you walk on them, or the ones that can be pushed around. Each implimentation of PhysRect could override the default trait behaviour to subtly change how that particular object was treated in the physics calculations.

```Rust
pub trait Phys {
    fn pr(&mut self) -> &mut PhysRect;
    fn pr_im(&self) -> &PhysRect;
    fn pre_physics(&mut self) { } 
    fn phys_x(&mut self, time: &f64) {
        self.pr().update_x(time);
    }
    fn phys_y(&mut self, time: &f64) {
        self.pr().update_y(time);
    }
    fn collision(&mut self, other: &PhysRect) {
        match self.pr().last_update {
            LastUpdate::X => {
                self.pr().x_collision = true;
                self.pr().s.x = resolve_x(self.pr().prev_s.x, self.pr().rect, &other.rect);
                self.pr().rect.x = self.pr().s.x;
                self.pr().v.x = momentum(
                    self.pr().v.x, self.pr().weight, other.v.x, other.weight
                )
            }
            LastUpdate::Y => {
                self.pr().y_collision = true;
                self.pr().s.y = resolve_y(self.pr().prev_s.y, self.pr().rect, &other.rect);
                self.pr().rect.y = self.pr().s.y;
                self.pr().v.y = 0.0;/*momentum(
                    self.pr().v.y, self.pr().weight, other.v.y, other.weight
                )*/
            }
        }
    }
    fn post_physics(&mut self) { }
}
```

The sand-like blocks that fall apart in very small strips were initially quite inefficent, so I broke them up into two seperate blocks. Initially they are ‘Nested’ blocks, when something collides with them the block is split into three sections. The left and right sections are new Nested blocks, but the middle section (where the object collided with the Nested object) is turned into ‘Brittle’ blocks that fall down and out of the level. So that as you run across the sand it seems to fall out from under you. This way of handling the blocks ensures they affect the speed of the game very little until they are collided with.
