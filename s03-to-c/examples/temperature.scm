;; Test floating point calculations
(letrec
    [(f2c (lambda(t n d) (- (/ (* (+ t 40.0) n) d) 40.0)))]
  (display (f2c 100.0 9.0 5.0)))
