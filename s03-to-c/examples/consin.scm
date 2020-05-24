
(define (floopsum env ix sx facc)
    (if (null? sx) facc
        (floopsum env (- ix 1) (cdr sx)
              (+ (f(car sx)) facc)) ))

(define (mcons env xs)
    (cons (iexpr 42) xs))

(define (top env sexpr)
     (car sexpr))

(define (rest env sexpr)
     (cdr sexpr))

(letrec
    [(xx (cons 6 (cons 5 #f)))]
 (begin  (display (top xx))
         (display (mcons xx))
         (display (floopsum 3 '(4.0 5.0 6.0 7.0) 0.0))
         (display (rest xx)) ))
