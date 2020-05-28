(letrec
  [(loop (lambda(i n)
           (if (<fx i 1) n
               (loop (-fx i  1) (+ n 0.1)) )))]
  (display (loop 10000 0.0)))

