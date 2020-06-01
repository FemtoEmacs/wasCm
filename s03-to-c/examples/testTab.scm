(define (spread i j) (int 10 11))

(letrec
    [(xx 42.0)]
  (begin
    (display (spread-set 0 0 xx))
    (display (spread-ref 0 0))) )
