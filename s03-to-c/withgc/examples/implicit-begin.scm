
(define (floopsum env sx facc)
    (if (null? sx) facc
        (floopsum env  (cdr sx)
              (+ (f(car sx)) facc)) ))

(define (mcons env xs)
    (cons (iexpr 42) xs))

(define (top env sexpr)
     (car sexpr))

(define (rest env sexpr)
     (cdr sexpr))

(letrec
    [(xx (cons 6 (cons 5 #f)))]
  (display (top xx))
  (display (mcons xx))
  (display (floopsum  '(4.0 5.0 6.0 7.0) 0.0))
  (display (rest xx)) )
