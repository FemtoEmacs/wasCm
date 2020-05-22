;; Compiled with guile
(letrec 
  [(fn (lambda(x y) (if (<= x 5) 42 (mod x y)) ))]
  (display (fn 29 6)) )

