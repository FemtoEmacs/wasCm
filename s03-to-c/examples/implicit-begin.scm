(letrec
    [(xx (cons 6 (cons 5 #f)))]
  (display (top xx))
  (display (mcons xx))
  (display (floopsum 3 '(4.0 5.0 6.0 7.0) 0.0))
  (display (rest xx)) )

