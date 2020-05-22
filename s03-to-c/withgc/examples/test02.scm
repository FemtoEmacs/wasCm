;; Compiled with guile
(letrec 
    [(ifun (lambda(x y)
	          (if (= x 5)
		           (/. (+. 42.0 42.0 42.0 84.0) 2.0 3.0)
		          (* x y)) ))]
  (display (ifun 5 9)) )

