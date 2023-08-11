;; Fibonacci through logic-and (&& p1 p2 ...)
;; and logic-or (// p1 p2 p3 ...)
(letrec
    [(fib (lambda(n)
            (// (&& (<fx n 2) (+fx n 1)  )
			          (+fx (fib (-fx n 1))
			               (fib (-fx n 2))) )))]
  (display (fib 0))
  (display (fib 1))
  (display (fib 2))
  (display (fib 3))
  (display (fib 4))
  (display (fib 5)) )
