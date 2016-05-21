(in-package :kos)

(defmacro doitimes (count &body body)
  `(dotimes (,(gensym) ,count)
	    ,@body))

(defun make-map-floor (width height)
  (check-type width (integer 2 *))
  (check-type height (integer 2 *))
  (let ((tiles (let (map)
		 ;; make the bottom wall
		 (let (bottom-wall)
		   (doitimes width
		     (push :wall bottom-wall))
		   (push bottom-wall map))
		 ;; make all of the "sandwich" rows
		 (dotimes (y (- height 2))
		   (let (mid-wall)
		     (push :wall mid-wall)
		     (dotimes (x (- width 2))
		       (push :floor mid-wall))
		     (push :wall mid-wall)
		     (push mid-wall map)))
		 ;; make the top wall
		 (let (top-wall)
		   (doitimes width
		     (push :wall top-wall))
		   (push top-wall map))
		 map)))
    (flet ((wallsym-to-char (wallsym)
	     (case wallsym
	       (:wall #\#)
	       (:floor #\.))))
      (lambda (name &rest args)
	(declare (ignore args))
	(flet ((draw-it (function)
		 (dotimes (y height)
		   (let ((row (nth y tiles)))
		     (dotimes (x width)
		       (let ((char (wallsym-to-char (nth x row))))
			 (funcall function char x y))))
		   (princ #\Newline))))

	  (case name
	    (:print
	     (draw-it (lambda (char x y)
			(declare (ignore x))
			(declare (ignore y))
			(princ char))))
	    (:render
	     (draw-it (lambda (char x y)
			(tb:change-cell x y char termbox:+default+ termbox:+default+) x y)))

	    (:passable?
	     )))))))

(defun make-player (x y)
  (check-type x (integer 0 *))
  (check-type y (integer 0 *))
  (let ((character #\@))
    (lambda (name &rest args)
      (case name
	(:draw
	 (let ((floor (first args)))
	   ))))))

(defun kos ()
  ;(format t "Welcome to King of Shadows!~%")
  (tb:init)
  (tb:clear)
  (let ((map-floor (make-map-floor 10 6)))
    (funcall map-floor :render))
  (tb:present)
  (sleep 1)
  (tb:shutdown))
