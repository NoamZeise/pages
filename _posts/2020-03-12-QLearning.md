---
layout: post
title: "QValue Reinforcement Learning with C#"
category: "Technical"
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/P1P63p1N3G4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

[Source Code on github](https://github.com/NoamZeise/Q-LearningPathfinder/tree/master/RL%20project)

I used [Q-learning](https://en.wikipedia.org/wiki/Q-learning) to make a program where an agent navigates a randomly generated board with obstacles to find and identify a goal. The video shows the behaviour of the untrained agent, then it is trained with 1,000,000 moves and is then shown navigating again.

A table is made that includes all possible state transitions of the enviornment, and the expected reward from a certain state transition is tracked. The agent is rewarded for getting to the goal quickly, which updates the expected reward values in the state transition table. At the beginning the agent's moves are essentially random, but as the expected reward values are updated the agent gets more and more accurate at finding the goal.
