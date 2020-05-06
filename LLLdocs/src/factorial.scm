(define (fact n #!optional (i 1) (f 1) (nxt (*fx i f)))
  (when (not (= (quotient nxt f) i))
     (error 'overflow n 'assert-failed))
  (if (>=fx i n) nxt
        (fact n (+fx i 1) nxt) ))
