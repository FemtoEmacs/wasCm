(letrec
  [(xx (cons 3 4))
   (fn (lambda(x y) (if (>fx x 9) 42 (+fx x y)) ))]
  (display (fn (fn (car xx) (cdr xx)) 9)))

