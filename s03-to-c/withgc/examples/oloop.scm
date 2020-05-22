(letrec
    [ (i 10000)
      (n 0)
      (loop (lambda()
	      (begin 
		 (set! i (- i 1))
		 (set! n (+ n 1))
                    (if (< i 1) n (loop) ) )))]
  (display (loop)))

