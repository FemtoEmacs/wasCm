;; Test recursivity and list operations
(letrec
    [(xx '(3.0 4.0 5.0 6.0))
     (add (lambda(x) (if (null? x) 0.0 (+ (car x) (add (cdr x))) )))]
  (display (add xx)))
