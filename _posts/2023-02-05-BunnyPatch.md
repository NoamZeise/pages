---
layout: post
title: "Bunny Patch - a simulation game about protecting a carrot patch"
category: "GameJam"
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/fmegaXGNcH4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

Protect your carrot patch from encroaching weeds.

Made with my [rust game library](https://github.com/NoamZeise/sdl2-rs-game-template) in 48 hours for [global game jam 2023](https://globalgamejam.org/2023/games/bunnypatch-0).

Click next turn to advance time by a few step, and you can watch as the game world changes. When the carrots sparkle, it means they have been harvested and added to your carrot bank in the top right. You can click on the button in the top left to open the shop and buy tiles that interact with the world in some way.


[download on itch.io](https://noamzeise.itch.io/bunnypatch)

[view source code on github](https://github.com/NoamZeise/BunnyPatch)

#### Credits:
* [Laura King](https://gerbzies.itch.io/) - Art and Game Design

* Noam Zeise - Programming and Game Design

* [Mick Cooke – MakeFire Music](https://youtube.com/channel/UCs75GjfGdtTS-CekMJOGICA) - Music and Sound Effects  


## Implementation Details

I added many new features to my Rust game library since I had last used it for a jam, now it hides 
all of the details of SDL. Controls are also much easier to add, and a lot of unrelated systems that were previously connected have been more seperated (ie render, input, camera, map, etc...). 

The Board is implimented as an array of Boxed objects that impliment the 'Tile' trait. This trait
defines the behavior of a tile type, what it looks like, how it affects other tiles, and how other tiles affect it. Here is the trait 

```Rust
pub trait Tile {
    fn tile(&self) -> Tiles {
        Tiles::None
    }

    fn pos(&self) -> (usize, usize);

    fn removed(&mut self) -> bool {
        false
	}

    fn update(&mut self, _map: &mut Tilemap) {}

    fn draw(&self, _cam: &mut Camera) {}

    fn interact(&mut self, _tile:Tiles) {}
}
```

When the simulation steps forward, the update function is called on each tile. Each tile can
add a `Choice` to the tilemap, which is a request for affecting a certain tile. Each of these
choices are looped through and applied to their targets. The choice has two affects, it can
either cause the target to be replaced, or will cause a change in the state of the target.

```Rust
 fn step(&mut self, ui: &mut Ui) {
 
        for t in self.obj_map.iter_mut() {
            t.update(&mut self.board);
        }

        for c in self.board.map_updates.drain(..) {
            if self.obj_map[c.i].tile() == Tiles::Grass {
                    self.set(c);
                } else  {
                    self.obj_map[c.i].interact(c.dst);
                    if self.obj_map[c.i].removed() {
                        self.set(c);
                    }
                }
            }
        }
    }
```

The choice of implimenting tiles like this made it really easy to add new ones, and change
the way they react with each other to change the way the simulation plays out.
