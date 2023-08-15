---
layout: post
title: Drawing Functions with Common Lisp
category: Demo
---

![rotated sine curves](https://github.com/NoamZeise/complex-fn-anim/blob/master/demos/images/rot-sine-cylinders.png?raw=true)

THIS POST IS A WORK IN PROGRESS

Extending my complex function animation library to work with graphing functions of the form
`f(x, y) = g(x, y)`

<!-- more -->

This is a continuation of my previous project where I outputted complex functions as images and animations, [see the post here](/demo/2023/03/27/Complex-Function-Animations.html). 

My goal is to be able to draw the graphs of functions and animate them using the functionality developed previously.

<br>

# Building the Functionality

The library's image generating function calls a function for each pixel, which returns a colour. We can specify a pixel function that will generate our graph.

To begin I tried manually graphing x squared.

![first x squared](https://github.com/NoamZeise/complex-fn-anim/blob/f89a6d630f93a00c374b70f94fae5fdbdb1890b7/demos/images/fn-drawing-progress/img.png?raw=true)

The graph line is quite hazy, but otherwise it is clearly x squared. The code to generate something like this is shown below. To graph `f(x)`, we
just need to get `abs(f(x) - y)` and scale it by some value, then use that as an intensity for a grayscale image. This gives a number closer to zero the
closer that pixel is to the ideal graph line.

```
(canim:make-im "build/x-squared.png" 300 300 (canim:make-pos :x -1 :y -1 :scale 2)
			:pixel-fn (lambda (x y scale)
				    (let* ((intensity (* 100 (abs (- (expt x 2) y))))
					   (colour (min (floor (* intensity 255)) 255)))
				      (canim:make-colour colour colour colour 255))))
```

With a little fiddling, making a better use of cutoffs and scaling, we can have a much sharper line.

![next attempt x squared](https://github.com/NoamZeise/complex-fn-anim/blob/f89a6d630f93a00c374b70f94fae5fdbdb1890b7/demos/images/fn-drawing-progress/img5.png?raw=true)

But already you can see an issue with having a fixed scaling/cutoff for each pixel. as x squared gets bigger, the line thins out. This happens because the cutoff, which
determines the line thickness, is the same no matter the behaviour of the function in that area. x squared near 0 gets much smaller than x.

The next type of graphs I tried to draw were of the form `f(x, y) = c` for some constant c. Below we see the equation of a circle.

![circle](https://github.com/NoamZeise/complex-fn-anim/blob/f89a6d630f93a00c374b70f94fae5fdbdb1890b7/demos/images/fn-drawing-progress/img3.png?raw=true)

The distance to the point is determined using `abs(f(x, y) - c)`. 

I added the ability to send a list of functions to be drawn, so they are overlayed ontop of each other. Here we see circles of different radii. 

![multiple radii](https://github.com/NoamZeise/complex-fn-anim/blob/f89a6d630f93a00c374b70f94fae5fdbdb1890b7/demos/images/fn-drawing-progress/img7.png?raw=true)

As with the 2nd x squared image, we see how the thickenss of the line changes as we use different values for the radius, because the same cutoff and scaling values are used.


![first](https://github.com/NoamZeise/complex-fn-anim/blob/f89a6d630f93a00c374b70f94fae5fdbdb1890b7/demos/images/fn-drawing-progress/img13-0.png?raw=true)
![second](https://github.com/NoamZeise/complex-fn-anim/blob/f89a6d630f93a00c374b70f94fae5fdbdb1890b7/demos/images/fn-drawing-progress/img13.png?raw=true)
![third](https://github.com/NoamZeise/complex-fn-anim/blob/f89a6d630f93a00c374b70f94fae5fdbdb1890b7/demos/images/fn-drawing-progress/img14.png?raw=true)
![fourth](https://github.com/NoamZeise/complex-fn-anim/blob/f89a6d630f93a00c374b70f94fae5fdbdb1890b7/demos/images/fn-drawing-progress/img16.png?raw=true)


I also added a parameter to the graphing functions to allow the image to be inverted:

![inverted graph](https://github.com/NoamZeise/complex-fn-anim/blob/f89a6d630f93a00c374b70f94fae5fdbdb1890b7/demos/images/fn-drawing-progress/img17.png?raw=true)



## Misc Generated Images

Compass

![compass](https://github.com/NoamZeise/complex-fn-anim/blob/f89a6d630f93a00c374b70f94fae5fdbdb1890b7/demos/images/fn-drawing-progress/img12.png?raw=true)

Rotated Sine

![Rotated Sine](https://github.com/NoamZeise/complex-fn-anim/blob/f89a6d630f93a00c374b70f94fae5fdbdb1890b7/demos/images/rot-sine.png?raw=true)

Braided Sine (Sine with different x values)

![Braided Sine](https://github.com/NoamZeise/complex-fn-anim/blob/f89a6d630f93a00c374b70f94fae5fdbdb1890b7/demos/images/sine.png?raw=true)


Double Arch (Many x cubeds)

![Double Arch](https://github.com/NoamZeise/complex-fn-anim/blob/f89a6d630f93a00c374b70f94fae5fdbdb1890b7/demos/images/x-cubed-repeat.png?raw=true)

Grid (sin x = cos y)

![Grid](/assets/img/posts/graphing-images/grid.png)

Rotated Grid

![Rotated Grid](https://github.com/NoamZeise/complex-fn-anim/blob/f89a6d630f93a00c374b70f94fae5fdbdb1890b7/demos/images/rot-grid.png?raw=true)
