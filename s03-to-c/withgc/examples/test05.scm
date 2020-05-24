;; Compiled with guile
(letrec
  [(xx (cons 3 4))
   (fn (lambda(x y) (if (> x 9) 42 (+ x y)) ))]
  (display (fn (fn (car xx) (cdr xx)) 9)))

