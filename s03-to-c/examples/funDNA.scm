;; Test closure
(letrec 
    [(mkcnt (lambda(n)
	      (lambda()
		(set! n (+fx n 1))) ))
     (cnt1 (mkcnt 42))
     (cnt2 (mkcnt 0))]
  (begin (display (cnt1))
	 (display (cnt1))
	 (display (cnt2))
	 (display (cnt1))
	 (display (cnt2)) ))
