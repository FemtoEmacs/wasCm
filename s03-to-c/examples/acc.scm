;; List operations and floating point calculations
(letrec
    [(xx '(3.0 4.0 5.0 6.0))
     (add (lambda(acc x)
	    (if (null? x) acc (add (+ (car x) acc) (cdr x))) ))]
  (display (add 0.0 xx)))
