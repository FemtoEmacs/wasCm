(define (spread i j) (int 10 11))

(letrec
    [(xx 42.0)]
  (begin
    (display (table-set 0 0 xx))
    (display (table-ref 0 0))) )
