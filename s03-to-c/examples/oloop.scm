(letrec
    [ (i 10000)
      (n 0)
      (loop (lambda()
	      (begin 
		 (set! i (-fx i 1))
		 (set! n (+fx n 1))
                    (if (<fx i 1) n (loop) ) )))]
  (display (loop)))

