;; Test efficiency of recursive functions
(letrec 
  [(fib (lambda(n)
          (if (<fx n 2) 1
              (+fx (fib (-fx n 1))
                   (fib (-fx n 2))) )))]
  (display (fib 8)))


