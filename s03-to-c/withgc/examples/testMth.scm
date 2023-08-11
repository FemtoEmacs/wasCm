;; Test errors in arithmetic types and operations
(letrec 
  [(xx 42) (yy 42.0)]
  ;;(display (+ xx (* yy 3))) ;; Should raise error
  ;;(display (+ xx xx)) ;; No error
  (display (-fx xx (*fx xx 2))) ;; Should not raise error
  (display (quot xx 2))  ;; Should pass
  ;;(display (quot xx 0))  ;; Division by zero
  (display (mod 17 5)) ;; Should produce a result
  ;;(display (mod 17 0)) ;; Division by zero
  (display (- xx 4 yy))  ;; Should raise error
);; End letrec
