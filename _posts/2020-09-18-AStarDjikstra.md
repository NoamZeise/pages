---
layout: post
title: "A* and Djikstra Shortest Path in C#"
category: "Demo"
---

[Source Code](https://github.com/NoamZeise/A-Djikstra-PathfindingAlgorithms/tree/master/PathfindingAlgorithms)

Djikstra is a common algorithm used to find the shortest paths from one node to all others, 
A* (A star) is a modification of djikstra that considers going from one node to one other.
A* considers how close a node is from the goal and prefers nodes that 
bring you closer to the end goal. 
This implimentation uses Djikstra to get the shortest path between two nodes, 
so that it can be compared to A*.

A square board is randomly generated and a few blocks are places to add complexity to the paths. 
Two random places on the grid are marked as start and end points for the algorithms to navigate.

The program shows The result of using both Dijsktra and A* pathfinding algorithms to 
find the shortest path between those points (if there are more than one, one is found at random).

<img src="/assets/img/posts/pathingCS/pathfinding-ss1.png">

The top shows Dijkstra, the bottom shows A*. The number of ticks and nodes each algorithm visited is also displayed.

The blue X represends the Start, the yellow X’s represents the path taken to get to the goal.

The red x’s are the nodes that were unexplored by the algorithm, the white ones being all the nodes visited but not part of the path.

<img src="/assets/img/posts/pathingCS/pathfinding-s2.png">

<img src="/assets/img/posts/pathingCS/pathfinding-s3.png">
