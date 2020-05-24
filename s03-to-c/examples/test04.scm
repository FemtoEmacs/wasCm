;; Compiled with guile
(letrec
  [(xx (cons 3 5))
   (fn (lambda(x y) (if (> x 9) 42 (+ x y)) ))]
  (display (fn (fn (car xx) 9) 5) ))

