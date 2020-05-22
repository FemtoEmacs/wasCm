;; Compiled with guile
(letrec 
  [(fn (lambda(x y) (if (> x 15) 42 (quot x y 2)) ))]
  (display (fn 15 3)) )

