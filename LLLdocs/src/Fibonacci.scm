(define (fibo i)
  (let fn+1 [ (n i) (fn 1) (fn-1 1) ]
    (if (< n 2) fn
        (fn+1 (- n 1) (+ fn fn-1) fn)) ))

#|
1:=> (load "Fibonacci.scm")
Fibonacci.scm
1:=> (fibo 5)
8
|#
