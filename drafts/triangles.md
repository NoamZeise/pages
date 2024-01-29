---
layout: post
title: Counting Triangles
draft: true
---

This short project is inspired by a puzzle I saw in the paper about counting the triangles in a given drawing.

<!-- more -->

```lisp
(defclass vertex ()
  ((name :initarg :name :accessor name)
   (neighbour :initarg :neighbour :initform (list) :accessor neighbour)))

(defclass graph ()
  ((verts :initarg :verts :accessor verts)
   (lines :initarg :lines :initform (list) :accessor lines)))

(defun print-graph (graph)
  (loop for v in (verts graph) do
    (progn (format t "~%~a : " (name v))
	   (loop for n in (neighbour v) do (format t "~a " n))))
  (loop for l in (lines graph) do (format t "~%~a" l)))

(defun neighboursp (verts l1 l2)
  (let ((n1 t) (n2 t) (nb nil))
    (loop for v in verts
	  when (equalp (name v) l1) do (setf n1 (neighbour v))
	    when (equalp (name v) l2) do (setf n2 (neighbour v)))
    (loop for n in n1 when (equalp n l2) return (setf nb t)
	  finally 
	     (loop for n in n2 when (equalp n l1) return (setf nb t)))
    nb))

(defun linep (lines verts)
  (loop named outer with length = (list-length verts) for l in lines do
    (loop with found = 0 for n in l do
      (loop for v in verts when (equalp v n) return
					     (progn
					       (setf found (+ 1 found))
					       (if (= found length)
						   (return-from outer t)))))
	finally (return-from outer nil)))

(defun triangles (graph &optional (print-triangles nil))
  (loop with count = 0 for (v . other-verts) on (verts graph) when other-verts do
    (loop for (n1 . r) on (neighbour v) when r do
      (loop for n2 in r do
	(if (and (neighboursp other-verts n1 n2)
		 (not (linep (lines graph) (list (name v) n1 n2))))
	    (progn
	      (if print-triangles (format t "~a~a~a~%" (name v) n1 n2))
	      (setf count (+ count 1))))))
     finally (return count)))

(defun make-graph (lines)
  (let ((verts (list)) (final-v (list)))
    (loop for line in lines do
      (loop for add-v in line do
	(let ((found
		(loop for v in verts when (equalp (name v) add-v) return v
		      finally
			 (progn
			   (setf verts (cons (make-instance 'vertex :name add-v) verts))
			   (return (car verts))))))
	  (loop for other-v in line when (not (equalp other-v (name found))) do
	    (loop for n in (neighbour found) when (equalp n other-v) return nil
		  finally (setf (neighbour found)
				(cons other-v (neighbour found))))))))
    (loop with seen = (list) for v in verts do
      (progn (setf seen (cons (name v) seen))
	     (let ((vert (make-instance 'vertex :name (name v))))
	       (loop for n in (neighbour v) do
		 (progn 
		   (loop for s in seen when (equalp n s) return nil
			 finally (setf (neighbour vert) (cons n (neighbour vert))))))
	       (setf final-v (cons vert final-v)))))
    (setf final-v (nreverse final-v))
    (make-instance 'graph :verts final-v :lines lines)))

(defparameter *square*
  (make-graph (list '(:A :B :C) '(:E :F :G) '(:C :D :E) '(:A :D :G) '(:F :D :B) '(:A :E) '(:C :G))))

(defparameter *final*
  (make-graph (list '(:A :B :C :D :E)
		'(:A :H :O)
		'(:A :F :J :N :S)
		'(:B :F :I :M :P)
		'(:C :F :H)
		'(:C :J :Q)
		'(:C :G :L)
		'(:D :G :K :N :R)
		'(:E :L :S)
		'(:E :G :J :M :O)
		'(:H :I :J :K :L)
		'(:H :M :Q)
		'(:L :N :Q)
		'(:O :P :Q :R :S))))
```
