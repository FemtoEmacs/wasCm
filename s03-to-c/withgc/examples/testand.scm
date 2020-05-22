(letrec
    [(fib (lambda(n) (// (&& (< n 2) (+ n 1)  )
			 (+ (fib (- n 1))
			    (fib (- n 2))) )))]
  (display (fib 0))
  (display (fib 1))
  (display (fib 2))
  (display (fib 3))
  (display (fib 4))
  (display (fib 5)) )
