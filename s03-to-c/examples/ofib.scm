(letrec 
  [(fib (lambda(n)
          (cond [ (<fx n 2) 1]
             [(<fx n 3) n]
             [else (+fx (fib (-fx n 3))
		        (fib (-fx n 2))
                        (fib (-fx n 2))) ])) )]
  (display (fib 35)))


