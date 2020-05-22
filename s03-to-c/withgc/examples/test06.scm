;; Compiled with guile
(letrec 
  [(fun (lambda(x y) (if (> x 5) 42 (* x y)) ))]
  (display (fun 5 9)) )

