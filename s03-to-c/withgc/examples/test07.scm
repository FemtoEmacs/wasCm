;; Compiled with guile
(letrec
    [(zz (cons 2 (cons 3  (cons 4 (cons 5 #f)) )))
     (add (lambda(x) (if (null? x) 0  (+fx (car x) (add (cdr x))) ))) ]
  (begin
    (display (add zz))) )




