(define f (cons 2 3))

(define g (cons 4 5))

(define (add x y)
(let ( (numerator (+ (* (car x) (cdr y))
                   (* (car y) (cdr x)) ))
       (denominator  (* (cdr x) (cdr y)) ))
  (cons numerator
        denominator))) 
