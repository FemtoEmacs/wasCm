;; File: fvalue.scm

(define  (future-value pv i n)
(* (expt (+ (/ i 100.0 1) n) 
   pv))
);;end define

(define (fat n)
(if (< n 1) 1
 (* (fat (- n 1)) n)))

(define (fn+1 n fn fn-1)
(if (< n 2) fn
 (fn+1 (- n 1
       (+ fn fn-1) fn)))

(define (quick xs)
(if (null? xs) xs
(append
    (quick (filter (lambda(x) (< x (car xs)))
                   (cdr xs)))
    (list (car xs))
    (quick (filter (lambda(x) (>= x (car xs)))
                   (cdr xs))) )))
