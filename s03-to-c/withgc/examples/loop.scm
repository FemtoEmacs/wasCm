(letrec
  [(loop (lambda(i n)
           (if (< i 1) n
               (loop (- i  1) (+. n 0.1)) )))]
  (display (loop 10000 0.0)))

