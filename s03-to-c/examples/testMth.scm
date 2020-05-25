(letrec 
  [(xx 42) (yy 42.0)]
  ;(display (+ xx (* yy 3))) ;; Should raise error
  ;(display (+ xx xx)) ;; No error
  ;(display (- xx (* xx 2))) ;; Should not raise error
  ;(display (quot xx 2))  ;; Should pass
  ;(display (quot xx 0))  ;; Division by zero
  ;(display (mod 17 5)) ;; Should produce a result
  ;(display (mod 17 0)) ;; Division by zero
  ;(display (- xx 4 yy))  ;; Should raise error
  ;(display (/. 19.0 0.0))
  ;(display (+. yy 1))
  ;(display (< 1 0.9))
  ;(display (<= 1.0 1))
  ;(display (>= 1.0 1))
  ;(display (> 1.0 1))
  ;(display (>= 1.0 1))
  ;(display (= 0 0.0))
  ;(display (=. 0.0 0))
  ;(display (<. 1 0.9))
  ;(display (<=. 1.0 1))
  ;(display (>=. 1.0 1))
  ;(display (>. 1.0 1))
  (display (>=. 1.0 1))
);; End letrec
