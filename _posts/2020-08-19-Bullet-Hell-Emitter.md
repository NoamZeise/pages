---
layout: post
title: Bullet Hell Emitter
category: Demo
---

<iframe width="750" height="422" src="https://www.youtube.com/embed/LPEHqzLFVAo" title="BulletHell Emitter" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

This is a small MonoGame project in C# investigating how bullets may be produced in a bullet hell game. The Program generates patterns such as seen in popular bullet hell games, using a single emitter with a position, rotation, firing speed, number of bullets fired, fire delay and firing separation

<!-- more -->

[Source Code on GitHub](https://github.com/NoamZeise/Bullet-Hell-Emitter/tree/master/bulletHell)


The game contains emitters which periodically emit bullets with certain velocities.
patterns control how emitters will chnage over time, ie by spinning or moving around.

This is how patterns work to modify emitters in the program, where patterns have 

- _delay - how often bullets are emitted
- _shooterNum - how many bullets the emitter emits
- _spin - how fast the emitter spins around
- _speed - the initial speed of the bullets
- _separation - the angle of separation between shooters

```C#
float deltaAngle = _seperation;
if(_seperation == 0)
	deltaAngle = 360f / (float)_shooterNum;
float[] angles = new float[_shooterNum];
Velocities = new Vector2[_shooterNum];
for (int i = 0; i < _shooterNum; i++)
{
	angles[i] = _currentRotation + (i * deltaAngle);
	angles[i] = normaliseAngle(angles[i]);
	
	Velocities[i].X = (float)Math.Sin(MathHelper.ToRadians(angles[i])) * _speed;
	Velocities[i].Y = (float)Math.Cos(MathHelper.ToRadians(angles[i])) * _speed;
}
```


![bullet hell screenshot 1](/assets/img/posts/bullet-hell-emitter/bh1.png)
![bullet hell screenshot 2](/assets/img/posts/bullet-hell-emitter/bh2.png)
![bullet hell screenshot 3](/assets/img/posts/bullet-hell-emitter/bh3.png)
