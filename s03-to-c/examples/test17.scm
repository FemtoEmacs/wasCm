
(letrec
    [(xx 42.0)]
  (begin (display (fadd xx 12.5))
     (display (floop 1000000 0.0)) ))


