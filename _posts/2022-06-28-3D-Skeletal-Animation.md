---
layout: post
title: "3D Skeletal Animation With Vulkan"
category: "Demo"
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/kic2IAvDSM8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

I’ve added Skeletal animation to my Vulkan game framwork. I already use assimp to load in 3D models,
but the library also loads animations if the model has them.
I’ve revamped the model loading system to be able to load animated and non-animated 
models auutomically, and the renderer can take a model and an animation 
and render the current state of the animation to the screen.

[Vulkan Framwork Source Code](https://github.com/NoamZeise/Vulkan-Environment)

[Model I used: Wolf by 3D Haupt](https://free3d.com/3d-model/wolf-rigged-and-game-ready-42808.html)


## How it works

The Animation is stored as a hierarchy of bones, where each bone has a number of keyframes for scale, position and rotation, and a parent bone.

Each bone corresponds to a 4×4 transform matrix that transforms the verticies from local to bone space. These transform matricies are calculated each frame and applied in the shader. In my implementation I send a uniform that holds and array of bone transform matricies that can be accessed by the animated verticies.
```glsl
const int MAX_BONES = 50;
layout(set = 2, binding = 0) uniform boneView
{
   mat4 mat[MAX_BONES];
} bones;
```
As the animation plays, the current frame’s bone matricies are calculated using the keyframes of each bone. When an animation timing lands between two keyframes, the state is linearly interpreted using the two surrounding frames and the time the animation is at. Furthermore each matrix is multiplied by it’s parent’s matrix so that, say, a hand will move if an arm moves, without having to specifically move the hand too.

Each vertex on the model has a number of bone IDs and weights, which represent which bone transforms affect the matrix, and by how much. The weights add up to 1.0 per vertex.

So that the weights and IDs can be sent more easily to the shader as a vec4 and an ivec4, models usually limit the number of bones that affect a vertex to 4. So that the shader’s vertex inputs look like this:
```glsl
layout(location = 0) in vec3 inPos;
layout(location = 1) in vec3 inNormal;
layout(location = 2) in vec2 inTexCoord;
layout(location = 3) in ivec4 inBoneIDs; //which bone matricies to use
layout(location = 4) in vec4 inWeights; //how much it affects
```
I add up each bone matrix into one big ‘skin’ matrix and apply it to the vertex to get it into bone space. This is also applied to the normal to ensure lighting calculations account for the animation.
```glsl
mat4 skin = mat4(0.0f);
for(int i = 0; i < 4; i++)
{
   if(inBoneIDs[i] == -1 || inBoneIDs[i] >= MAX_BONES)
      break;
   skin += inWeights[i] * bones.mat[inBoneIDs[i]];
}

// final_pos = projection * view * model * skin * position
// final_normal = normal_matrix * skin * normal
```
If the animation is updated each frame by the game loop to get new bone matricies, 
then the model will be animated by the shader. 
