;; Test arithmetic operators with many args
;; Floating point operations
(letrec 
    [(ifun (lambda(x y)
	     (if (=fx x 5)
		 (/ (+ 42.0 42.0 42.0 84.0) 2.0 3.0)
		 (*fx x y)) ))]
  (display (ifun 5 9)) )

