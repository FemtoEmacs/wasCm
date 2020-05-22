(letrec 
  [(fib (lambda(n)
          (cond [ (< n 2) 1]
             [(< n 3) n]
             [else (+ (fib (- n 3))
		                  (fib (- n 2))
                      (fib (- n 2))) ])) )]
  (display (fib 40)))


