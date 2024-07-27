---
layout: post
title: Real Time Graphics Demos in Lisp
category: Demo
draft: true
---

I'm working on a graphics library in common lisp and have made 
various examples to test features as I add them.
I present a collection of these demos and their source code.

The library is designed to simplify the use of opengl,
but still requires the user to use opengl directly.
It also implements linear algebra functions and
lets you pass matrix and vector data to shaders.

<!-- more -->

# Spinning Square

<iframe width="560" height="315" src="https://www.youtube.com/embed/2GTn9IAMN3k?si=BMVG5k4tusJUWiXD" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

This demo is used to show the creation and loading of a 2d
texture to the gpu. The texture is applied to a quad. 
The example also uses multisampling.

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

# 3D Waves

<iframe width="560" height="315" src="https://www.youtube.com/embed/TmYnBcqdzwE?si=AMYwcXk7-Oaje-jX" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

This demo uses a 3d camera a 3d cubes with instance rendering.

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

Youtube compresses this demo badly, 
heres a screenshot for a better picture.

![cube wave screenshot](/assets/img/posts/gficl-demos/cube-wave.png)

# Post Processing


This demo uses a framebuffer texture as a render target,
which is then rendered onto the final screen backbuffer.
