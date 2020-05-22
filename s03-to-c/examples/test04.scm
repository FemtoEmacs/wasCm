;; Compiled with guile
(letrec 
  [(fn (lambda(x y) (if (<= x 5) 42 (* x y)) ))]
  (display (fn 5 9)) )

