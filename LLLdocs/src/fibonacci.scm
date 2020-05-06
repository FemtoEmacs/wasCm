(define (fib n fn fn-1)
(cond ((< n 2) fn)
    (else  (fib (- n 1) (+ fn fn-1) fn)) ))
