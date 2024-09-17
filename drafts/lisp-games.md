---
layout: post
title: Real Time Graphics Demos in Lisp
category: Demo
draft: true
---

I'm working on a common lisp graphics library and have built 
various examples to test features as I add them.
I present a collection of these demos and their source code.

The library is designed to simplify some parts of opengl.
It also implements linear algebra functions and
lets you pass matrix and vector data to shaders.

<!-- more -->

[Repo for the graphics library](https://github.com/NoamZeise/gficl)

# Spinning Square

<iframe width="560" height="315" src="https://www.youtube.com/embed/2GTn9IAMN3k?si=BMVG5k4tusJUWiXD" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

<details>
<summary> source code for this example </summary>
<pre class="highlight"> <code>
(in-package :gficl-examples.quad-spin)

(defparameter *samples* 1)

(defparameter *fb-attachments*
  (list (gficl:make-attachment-description :color-attachment0)
	(gficl:make-attachment-description :depth-stencil-attachment)))
(defparameter *fb* nil)

;; shader
(defparameter *shader* nil)
;; shader input
(defparameter *vertex-format*
  (gficl:make-vertex-form
   (list (gficl:make-vertex-slot 2 :float)
	 (gficl:make-vertex-slot 2 :float))))
;; shader code
(defparameter *vert-shader*
  "#version 330
layout (location = 0) in vec2 vertex;
layout (location = 1) in vec2 inTexCoords;

out vec2 TexCoords;

uniform mat4 model;
uniform mat4 projection;

void main() {
    TexCoords = inTexCoords;
    gl_Position = projection * model * vec4(vertex, 0, 1);
}")
(defparameter *frag-shader*
  "#version 330

in vec2 TexCoords;
out vec4 colour;

uniform sampler2D tex;

void main() {
  colour = texture(tex, TexCoords);
}")
;; shader data
(defparameter *projection* nil)

;; object data
(defparameter *quad* nil)

(defparameter *tex* nil)
(defparameter *model* nil)
(defparameter *rot* nil)

(defparameter *bg-tex* nil)
(defparameter *bg-model* nil)

(defun setup ()
  (setf *shader* (gficl:make-shader *vert-shader* *frag-shader*))
  (gl:clear-color 0 0 0 0)
  (setf *samples* (min 16 (gl:get-integer :max-samples)))
  (if (> *samples* 1) (gl:enable :multisample))
  (setf *fb* nil)
  
  (resize (gficl:window-width) (gficl:window-height))
  (gl:enable :depth-test)
  
  (setf *quad*
	(gficl:make-vertex-data
	 *vertex-format*
	 '(((0 0) (0 0))
	   ((1 0) (1 0))
	   ((1 1) (1 1))
	   ((0 1) (0 1)))
	 '(0 3 2 2 1 0)))
  (setf *tex*
	(gficl:make-texture-with-fn
	 10 10
	 #'(lambda (x y) (list (floor (* 255 (/ x 10))) (floor (* 255 (/ y 10))) 255 255))))
  (setf *bg-tex*
	(gficl:make-texture-with-fn
	 1000 1000
	 #'(lambda (x y)
	     (list (floor (* 200 (abs (sin (* x 0.002))))) (floor (* 200 (abs (cos (* y 0.002)))))
		   200 255))))
  
  (setf *model* (gficl:make-matrix))
  (setf *rot* 0))

(defun resize (w h)
  (if *fb* (gficl:delete-gl *fb*))
  (setf *fb* (gficl:make-framebuffer *fb-attachments* w h *samples*))
  (setf *bg-model* (gficl:scale-matrix (list w h 1)))
  (setf *projection* (gficl:screen-orthographic-matrix
    (gficl:window-width) (gficl:window-height))))

(defun cleanup ()
  (gficl:delete-gl *tex*)
  (gficl:delete-gl *bg-tex*)
  (gficl:delete-gl *shader*)
  (if *fb* (gficl:delete-gl *fb*))
  (gficl:delete-gl *quad*))

(defun render ()
  (gficl:with-render   
   (gficl:bind-gl *fb*)
   (gl:clear :color-buffer :depth-buffer)
   
   (gficl:bind-gl *shader*)
   (gl:active-texture :texture0)
   (gficl:bind-matrix *shader* "projection" *projection*)
   (gficl:bind-matrix *shader* "model" *model*)
   (gficl:bind-gl *tex*)
   (gficl:draw-vertex-data *quad*)
   (gficl:bind-matrix *shader* "model" *bg-model*)
   (gficl:bind-gl *bg-tex*)
   (gficl:draw-vertex-data *quad*)

   (gficl:blit-framebuffers *fb* 0 (gficl:window-width) (gficl:window-height))))

(defun update ()
  (gficl:with-update (dt)
    (if (gficl:key-pressed :escape) (glfw:set-window-should-close))		     
    (if (gficl:key-pressed :f) (gficl:toggle-fullscreen))
    (setf *rot* (+ *rot* (* dt 1)))
    (setf *model*
	  (let* ((w (gficl:window-width))
		 (h (gficl:window-height))
		 (size (* 0.7 (min w h)))
		 (half (/ size 2)))
	    (gficl:*mat
	     (gficl:translation-matrix (list (- (/ w 2) half) (- (/ h 2) half) 0.1))
	     (gficl:translation-matrix (list half half 0))
	     (gficl:2d-rotation-matrix *rot*)
	     (gficl:translation-matrix (list (- half) (- half) 0))
	     (gficl:scale-matrix (list size size 1)))))))

(defun run ()
  (gficl:with-window
   (:title "spinning quad" :width 500 :height 500 :resize-callback #'resize)
   (setup)
    (loop until (gficl:closed-p)
	  do (update)
	  do (render))
    (cleanup)))
</code></pre></details>

This demo is used to show the creation and loading of a 2d
texture to the gpu. The texture is applied to a quad. 
The example also uses multisampling. 
For this demo I added textures and matricies.

# 3D Waves

<iframe width="560" height="315" src="https://www.youtube.com/embed/TmYnBcqdzwE?si=AMYwcXk7-Oaje-jX" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

<details>
<summary> source code for this example </summary>
<pre class="highlight"> <code>
(in-package :gficl-examples.cube-wave)

(defparameter *cube-data*
  (list :verts
	'(((-1 -1 -1))
	  ((-1 -1  1))
	  ((-1  1 -1))
	  ((-1  1  1))
	  (( 1 -1 -1))
	  (( 1 -1  1))
	  (( 1  1 -1))
	  (( 1  1  1)))
	:indices
	'(2 1 0 1 2 3
	  4 5 6 7 6 5
	  0 1 4 5 4 1
	  6 3 2 3 6 7
	  4 2 0 2 4 6
	  1 3 5 7 5 3)))

(defparameter *main-vert-code*
  "#version 330
layout (location = 0) in vec3 vertex;

out vec3 pos;
out vec3 localpos;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

uniform int dim;
uniform float time;

float height(float x, float y) {
 return 0.4*length(vec3(x, 0, y))
      + 0.4*cos(4*time + (x * 0.7))
      + 0.4*sin(4*time + (y * 0.7)) 
      + 1*sin(1*time + (x * 0.3))
      + 3*sin(0.4*time + (x * 0.1))
      + 3*cos(0.4*time + (y * 0.1))
      - 14;
}

void main() {
 localpos = vec3(model * vec4(vertex, 1));
 int x = 2 * (gl_InstanceID / dim) - dim;
 int y = 2 * (gl_InstanceID % dim) - dim;
 pos = vec3(x, height(x, y), y) + localpos;
 gl_Position = projection * view * vec4(pos, 1);}")

(defparameter *main-frag-code*
  "#version 330
in vec3 pos;
in vec3 localpos;
out vec4 colour;

void main() {
  colour = vec4(localpos.y * 0.2 - 0.45);
  colour += vec4(sin(0.05*pos.x), 2*sin(0.02*pos.y), sin(0.05*pos.z), 1);
  colour *= sinh(localpos.x - localpos.z)*0.04 + 1;}")

(defparameter *cube* nil)
(defparameter *fb* nil)
(defparameter *main-shader* nil)

(defparameter *view* nil)

;; camera
(defparameter *forward* nil)
(defparameter *position* nil)
(defparameter *target* nil)
(defparameter *world-up* nil)

(defparameter *time* nil)
(defparameter *cubes-dim* nil)

(defun setup ()
  (setf *cube* (gficl:make-vertex-data
		(gficl:make-vertex-form (list (gficl:make-vertex-slot 3 :float)))
		(getf *cube-data* :verts) (getf *cube-data* :indices)))
  (setf *main-shader* (gficl:make-shader *main-vert-code* *main-frag-code*))
  (setf *cubes-dim* 50)
  (gficl:bind-gl *main-shader*)
  (gl:uniformi (gficl:shader-loc *main-shader* "dim") *cubes-dim*)
  (gficl:bind-matrix *main-shader* "model" (gficl:scale-matrix '(1 5 1)))
  
  (setf *fb* nil)
  (resize (gficl:window-width) (gficl:window-height))
  (setf *view* (gficl:make-matrix))

  (setf *world-up* (gficl:make-vec '(0 1 0)))
  (setf *position* (gficl:make-vec'(20 14 20)))
  (setf *target* (gficl:make-vec '(0 -20 0)))
  (setf *time* 0)
  (update-view 0)
  (gl:enable :cull-face :depth-test :multisample))

(defun resize (w h)
  (gficl:bind-gl *main-shader*)
  (gficl:bind-matrix *main-shader* "projection"
    (gficl::screen-perspective-matrix w h (* pi 0.4) 0.1))
  (if *fb* (gficl:delete-gl *fb*))
  (setf *fb* (gficl:make-framebuffer
	      (list (gficl:make-attachment-description :color-attachment0)
		    (gficl:make-attachment-description :depth-stencil-attachment))
	      w h (min 4 (gl:get-integer :max-samples)))))

(defun cleanup ()
  (gficl:delete-gl *cube*)
  (gficl:delete-gl *main-shader*)
  (gficl:delete-gl *fb*))

(defun update-view (dt)
  (setf *position*
	(gficl:quat-conjugate-vec (gficl:make-unit-quat (* 0.1 dt) *world-up*) *position*))
  (setf *forward* (gficl:-vec *target* *position*))
  (setf *view* (gficl::view-matrix *position* *forward* *world-up*)))

(defun update ()
  (gficl:with-update (dt)
    (setf *time* (+ *time* dt))
    
    (gficl:map-keys-pressed
     ((:escape (glfw:set-window-should-close))
      (:f (gficl:toggle-fullscreen))))
    
    (gficl:map-keys-down
     ((:up (setf *position*   (gficl:+vec *position* (gficl:*vec (*  0.2 dt) *forward*))))	
      (:down (setf *position* (gficl:+vec *position* (gficl:*vec (* -0.2 dt) *forward*))))
      (:space
       (setf *position*
	     (gficl:+vec *position*
			 (gficl:*vec (* 0.3 dt (gficl:magnitude *forward*)) *world-up*))))
      (:left-shift
       (setf *position*
	     (gficl:+vec *position*
			 (gficl:*vec (* -0.3 dt (gficl:magnitude *forward*)) *world-up*))))))      
    (update-view dt)))

(defun draw ()
  (gficl:with-render
   (gficl:bind-gl *fb*)
   (gl:clear :color-buffer :depth-buffer)
   (gficl:bind-gl *main-shader*)
   (gficl:bind-matrix *main-shader* "view" *view*)
   (gl:uniformf (gficl:shader-loc *main-shader* "time") *time*)
   (gficl:draw-vertex-data *cube* :instances (* *cubes-dim* *cubes-dim*))
   (gficl:blit-framebuffers *fb* 0 (gficl:window-width) (gficl:window-height))))

(defun run ()
  (gficl:with-window
   (:title "cube-waves" :width 600 :height 400 :resize-callback #'resize)
   (setup)
   (loop until (gficl:closed-p)
	 do (update)
	 do (draw))
   (cleanup)))
</code></pre></details>

This demo uses a 3d camera a 3d cubes with instance rendering. 
For this demo I expanded matrix functionality and implemented
a perspective projection matrix function. 

Youtube compresses this demo badly, 
heres a screenshot for a better picture.

![cube wave screenshot](/assets/img/posts/gficl-demos/cube-wave.png)

# Post Processing

<iframe width="560" height="315" src="https://www.youtube.com/embed/4DxTZkbhUhw?si=fqvUKl2Ully45i6-" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

<details>
<summary> source code for this example </summary>
<pre class="highlight"> <code>
(in-package :gficl-examples.post-processing)

(defparameter *main-vert*
  "#version 330
layout (location = 0) in vec3 position;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out vec3 pos;

void main() {
  pos = position;
  gl_Position = projection * view * model * vec4(pos, 1);
}")

(defparameter *main-frag*
  "#version 330
in vec3 pos;
out vec4 colour;

void main() {
   vec3 p = (pos + vec3(3)) * 0.2;
   colour = vec4(p.x, p.y, p.z, 1);
}")

(defparameter *post-vert*
  "#version 330
out vec2 uv;
uniform mat4 transform;
void main() {
  uv = vec2((gl_VertexID << 1) & 2, gl_VertexID & 2);
  gl_Position = transform * vec4(uv * 2.0f - 1.0f, 0.0f, 1.0f);
}")

(defparameter *post-frag*
  "#version 330
in vec2 uv;
out vec4 colour;
uniform sampler2D screen;
void main() { 
  if(uv.x > 1 || uv.y > 1 || uv.x < 0 || uv.y < 0) discard;

  // posterise
  colour = texture(screen, uv);
  int colour_count = 8;
  colour *= colour_count;
  for(int i = 0; i < 4; i++)
    colour[i] = floor(colour[i]);
  colour /= colour_count;
  
  // edge detection
  mat3 edge_ker = mat3(
      1,  1, 1,
      1, -8, 1,
      1,  1, 1
  );  
  float offset = 1.0/200;
  float edge_intensity = 0;
  for(int x = 0; x < 3; x++) {
    for(int y = 0; y < 3; y++) {
      vec4 col = texture(screen, uv + (x-1) * vec2(offset,0) 
                                    + (y-1) * vec2(0,offset));
      edge_intensity += ((col.r + col.g + col.b)/3) * edge_ker[x][y];
    }
  } 
  edge_intensity = step(0.1, edge_intensity);
  colour *= vec4(1) - vec4(edge_intensity);

  // dot pattern
  float amount = 800;
  colour *= 1.1;
  colour += 0.1f;
  colour *= step(0.1, sin(uv.x*amount*1.4) + cos(uv.y*amount))*0.6 + 0.4;
}")

(defparameter *cube-data*
  (list :verts
	'(((-1 -1 -1))
	  ((-1 -1  1))
	  ((-1  1 -1))
	  ((-1  1  1))
	  (( 1 -1 -1))
	  (( 1 -1  1))
	  (( 1  1 -1))
	  (( 1  1  1)))
	:indices
	'(2 1 0 1 2 3
	  4 5 6 7 6 5
	  0 1 4 5 4 1
	  6 3 2 3 6 7
	  4 2 0 2 4 6
	  1 3 5 7 5 3)))

(defparameter *samples* nil)

;; normal render
(defparameter *target-width* 1000)
(defparameter *target-height* 700)
(defparameter *fixed-target* nil)
(defparameter *offscreen-w* nil)
(defparameter *offscreen-h* nil)
(defparameter *main-shader* nil)
(defparameter *offscreen-fb* nil)
(defparameter *resolve-fb* nil)

;; post-processing 
(defparameter *dummy-vert* nil)
(defparameter *post-shader* nil)

;; scene
(defparameter *cube* nil)
(defparameter *world-up* (gficl:make-vec '(0 0 1)))
(defparameter *position* nil)
(defparameter *target* nil)

(defun setup ()
  (setf *fixed-target* t)
  (setf *resolve-fb* nil)
  (setf *offscreen-fb* nil)
  (setf *samples* (min 8 (gl:get-integer :max-samples)))  
  (setf *main-shader* (gficl:make-shader *main-vert* *main-frag*))
  (gficl:bind-gl *main-shader*)
  (gficl:bind-matrix *main-shader* "model" (gficl:make-matrix))

  (setf *cube* (gficl:make-vertex-data
		(gficl:make-vertex-form (list (gficl:make-vertex-slot 3 :float)))
		(getf *cube-data* :verts) (getf *cube-data* :indices)))
  
  (setf *post-shader* (gficl:make-shader *post-vert* *post-frag*))
  (gficl:bind-gl *post-shader*)
  (gl:uniformi (gficl:shader-loc *post-shader* "screen") 0)

  (setf *dummy-vert*
	(gficl:make-vertex-data (gficl:make-vertex-form (list (gficl:make-vertex-slot 1 :int)))
				'(((0))) '(0 0 0)))

  (setf *position* (gficl:make-vec '(5 2 3)))
  (setf *target* (gficl:make-vec '(0 0 0)))
  (if *fixed-target* (make-offscreen *target-width* *target-height*))
  (resize (gficl:window-width) (gficl:window-height)))

(defun resize (w h)
  (if (not *fixed-target*) (make-offscreen w h))
  (gficl:bind-gl *post-shader*)
  (gficl:bind-matrix *post-shader* "transform"
		     (gficl:target-resolution-matrix *offscreen-w* *offscreen-h* w h)))

(defun make-offscreen (w h)
  (setf *offscreen-w* w)
  (setf *offscreen-h* h)
  (if *resolve-fb* (gficl:delete-gl *resolve-fb*))
  (setf *resolve-fb* nil)
  (if (> *samples* 1)
      (setf *resolve-fb*
	    (gficl:make-framebuffer
	     (list (gficl:make-attachment-description :color-attachment0 :texture))
	     w h)))
  (if *offscreen-fb* (gficl:delete-gl *offscreen-fb*))
  (setf *offscreen-fb* nil)
  (setf *offscreen-fb*
	(gficl:make-framebuffer
	 (list (gficl:make-attachment-description :color-attachment0
						  (if *resolve-fb* :renderbuffer :texture))
	       (gficl:make-attachment-description :depth-stencil-attachment))
	 w h *samples*))
  (gficl:bind-gl *main-shader*)
  (gficl:bind-matrix *main-shader* "projection"
		     (gficl:screen-perspective-matrix w h 1 0.1)))

(defun cleanup ()
  (gficl:delete-gl *cube*)
  (if *resolve-fb* (gficl:delete-gl *resolve-fb*))
  (gficl:delete-gl *offscreen-fb*)  
  (gficl:delete-gl *main-shader*)
  (gficl:delete-gl *post-shader*)
  (gficl:delete-gl *dummy-vert*))

(defun update ()
  (gficl:with-update (dt)
    (gficl:map-keys-pressed
     ((:escape (glfw:set-window-should-close))
      (:f (gficl:toggle-fullscreen))))
    (gficl:bind-gl *main-shader*)
    (setf *position* (gficl:rotate-vec *position* (* dt 0.3) *world-up*))    
    (gficl:bind-matrix *main-shader* "view"
		       (gficl:view-matrix *position* (gficl:-vec '(0 0 0) *position*) *world-up*))))

(defun draw ()
  (gficl:with-render
   (draw-offscreen)
   (draw-post)))

(defun draw-offscreen ()
  (gficl:bind-gl *offscreen-fb*)
  (gl:viewport 0 0 *offscreen-w* *offscreen-h*)
  (gl:clear-color 0.4 0.5 0 0)
  (gl:clear :color-buffer :depth-buffer)
  (gl:enable :depth-test)
  (if *resolve-fb* (gl:enable :multisample))
  (gficl:bind-gl *main-shader*)
  (gficl:draw-vertex-data *cube*)
  (if *resolve-fb*
      (gficl:blit-framebuffers *offscreen-fb* *resolve-fb* *offscreen-w* *offscreen-h*)))

(defun draw-post ()
  (gl:bind-framebuffer :framebuffer 0)
  (gl:viewport 0 0 (gficl:window-width) (gficl:window-height))
  (gl:clear-color 0 0 0 0)
  (gl:clear :color-buffer)
  (gl:disable :depth-test :multisample)
  (gficl:bind-gl *post-shader*)
  (gl:active-texture :texture0)
  (gl:bind-texture :texture-2d
		   (gficl:framebuffer-texture-id (if *resolve-fb* *resolve-fb* *offscreen-fb*) 0))
  (gficl:bind-gl *dummy-vert*)
  (gl:draw-arrays :triangles 0 3))

(defun run ()
  (gficl:with-window
   (:title "post processing"
	   :width *target-width* :height *target-height* :resize-callback #'resize)
   (setup)
   (loop until (gficl:closed-p)
	 do (update)
	 do (draw))
   (cleanup)))
</code></pre></details>

This demo uses a framebuffer texture as a render target,
which is then rendered onto the final screen backbuffer.
The final pass adds a posterisation and edge detection effect,
as well as a dot effect. It also boosts the saturation and brightness.
For this demo I added framebuffer texture targets.

<div class="container">
<div class="item">
  <img src="/assets/img/posts/gficl-demos/pp-base.png">
  <h3>Base Image</h3>
</div>
<div class="item">
  <img src="/assets/img/posts/gficl-demos/pp-posterise.png">
  <h3>Posterised</h3>
</div>
<div class="item">
  <img src="/assets/img/posts/gficl-demos/pp-outline.png">
  <h3>Outline</h3>
</div>
<div class="item">
  <img src="/assets/img/posts/gficl-demos/pp-outline-combined.png">
  <h3>Base with Outline</h3>
</div>
<div class="item">
  <img src="/assets/img/posts/gficl-demos/pp-dots.png">
  <h3>Dots</h3>
</div>
<div class="item">
  <img src="/assets/img/posts/gficl-demos/pp-final.png">
  <h3>Final Combined Image</h3>
</div>
</div>

# Model With Gooch Shading

<iframe width="560" height="315" src="https://www.youtube.com/embed/7oUUJJcnfLg?si=GZyqjJKK29EUcSJz" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

<details>
<summary> source code for this example </summary>
<pre class="highlight"> <code>
(in-package :gficl-examples.model-loading)

(defparameter *bunny-path* #p"examples/assets/bunny.obj")

(defparameter *vertex-data-form*
	      (gficl:make-vertex-form
	       (list (gficl:make-vertex-slot 3 :float)
		     (gficl:make-vertex-slot 3 :float))))

(defparameter *main-vert-code*
	      "#version 330
layout (location = 0) in vec3 vertex;
layout (location = 1) in vec3 normal;

out vec3 pos;
out vec3 normal_vec;

uniform mat4 model;
uniform mat4 normal_mat;
uniform mat4 view;
uniform mat4 projection;

void main() {
 vec4 world_pos = model * vec4(vertex, 1);
 pos = vec3(world_pos);
 normal_vec = vec3(normal_mat * vec4(normal, 1));
 gl_Position = projection * view * world_pos;}")

(defparameter *main-frag-code*
  "#version 330
in vec3 pos;
in vec3 normal_vec;
out vec4 colour;

uniform vec3 cam;

void main() {
  // shading constants
  vec3 object_colour = vec3(1);
  vec3 cool = vec3(0.2, 0, 0.55) + 0.25*object_colour;
  vec3 warm = vec3(0.5, 0.3, 0) + 0.5*object_colour;
  vec3 highlight = vec3(1, 0.8, 0.2);
  float specular = 30.0f;
  
  vec3 n = normalize(normal_vec);
  vec3 l = -vec3(0, 0.2, -1); // light direction
  vec3 v = normalize(cam - pos);

  // gooch shading
  float t = (dot(n,l) + 1)/2.0;
  vec3 r = -reflect(l,n);
  float s = clamp(pow(dot(r,v), specular), 0, 1);
  vec3 base = mix(cool, warm,  t);
  vec3 shaded = mix(base, highlight, s);
  
  // edge outline
  float edge_amount = dot(n, v);
  float thickness = 0.23;
  edge_amount = clamp(edge_amount, 0, thickness)*(1/thickness);
  vec3 edge = vec3(edge_amount);

  colour = vec4(shaded*edge, 1);
}")

(defparameter *bunny* nil)
(defparameter *fb* nil)
(defparameter *main-shader* nil)

(defparameter *view* nil)

;; camera
(defparameter *forward* nil)
(defparameter *position* nil)
(defparameter *target* nil)
(defparameter *world-up* nil)

(defun setup ()
  (let* ((bunny-mesh (car (obj:extract-meshes (obj:parse (probe-file *bunny-path*))))))
    (setf *bunny* (gficl:make-vertex-data-from-vectors
		   *vertex-data-form*
		   (obj:vertex-data bunny-mesh)
		   (obj:index-data bunny-mesh))))
  (setf *main-shader* (gficl:make-shader *main-vert-code* *main-frag-code*))
  (gl:clear-color 0.8 0.5 0 0)
  (gficl:bind-gl *main-shader*)
  (let ((mat (gficl:scale-matrix '(5 5 5))))
    (gficl:bind-matrix *main-shader* "model" mat)
    (gficl:bind-matrix *main-shader* "normal_mat"
		       (gficl:transpose-matrix
			(gficl:inverse-matrix mat))))
  
  (setf *fb* nil)
  (resize (gficl:window-width) (gficl:window-height))
  (setf *view* (gficl:make-matrix))

  (setf *world-up* (gficl:make-vec '(0 1 0)))
  (setf *position* (gficl:make-vec'(5 1 5)))
  (setf *target* (gficl:make-vec '(0 0 0)))
  (update-view 0)
  (gl:enable :cull-face :depth-test :multisample)
  (gl:cull-face :front))

(defun resize (w h)
  (gficl:bind-gl *main-shader*)
  (gficl:bind-matrix *main-shader* "projection"
    (gficl::screen-perspective-matrix w h (* pi 0.4) 0.1))
  (if *fb* (gficl:delete-gl *fb*))
  (setf *fb* (gficl:make-framebuffer
	      (list (gficl:make-attachment-description :color-attachment0)
		    (gficl:make-attachment-description :depth-stencil-attachment))
	      w h (min 4 (gl:get-integer :max-samples)))))

(defun cleanup ()
  (gficl:delete-gl *bunny*)
  (gficl:delete-gl *main-shader*)
  (gficl:delete-gl *fb*))

(defun update-view (dt)
  (setf *position*
	(gficl:quat-conjugate-vec (gficl:make-unit-quat (* 0.1 dt) *world-up*) *position*))
  (setf *forward* (gficl:-vec *target* *position*))
  (setf *view* (gficl::view-matrix *position* *forward* *world-up*)))

(defun update ()
  (gficl:with-update (dt)
    
    (gficl:map-keys-pressed
     ((:escape (glfw:set-window-should-close))
      (:f (gficl:toggle-fullscreen))))
    
    (gficl:map-keys-down
     ((:up (setf *position*   (gficl:+vec *position* (gficl:*vec (*  0.2 dt) *forward*))))	
      (:down (setf *position* (gficl:+vec *position* (gficl:*vec (* -0.2 dt) *forward*))))
      (:space
       (setf *position*
	     (gficl:+vec *position*
			 (gficl:*vec (* 0.3 dt (gficl:magnitude *forward*)) *world-up*))))
      (:left-shift
       (setf *position*
	     (gficl:+vec *position*
			 (gficl:*vec (* -0.3 dt (gficl:magnitude *forward*)) *world-up*))))))      
    (update-view dt)))

(defun draw ()
  (gficl:with-render
   (gficl:bind-gl *fb*)
   (gl:clear :color-buffer :depth-buffer)
   (gficl:bind-gl *main-shader*)
   (gficl:bind-matrix *main-shader* "view" *view*)
   (gficl::internal-bind-vec *main-shader* "cam" *position*)
   (gficl:draw-vertex-data *bunny*)
   (gficl:blit-framebuffers *fb* 0 (gficl:window-width) (gficl:window-height))))

(defun run ()
  (gficl:with-window
   (:title "bunny viewer" :width 600 :height 400 :resize-callback #'resize)
   (setup)
   (loop until (gficl:closed-p)
	 do (update)
	 do (draw))
   (cleanup)))
</code></pre></details>

This example loads a wavefront model using a library,
and renders it using gooch shading with an outline effect.
For this example I added the ability to invert and transpose matrices.
This is because surface normals need to be transformed 
by the transpose of the inverse of the model matrix to avoid deformation.
