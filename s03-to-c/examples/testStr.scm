;; Test read sexpr from string,
;; string concatenation, substring and
;; other string operations
(letrec [(xx "Rose of Luxemburg")
         (yy "Anna Bolena")
	 (str "(cost 42.5)")
         (zz "empty")]
  (begin (display (string-ref xx 0))
         (display (string-ref xx 1))
         (display (strcat xx yy))
         (display #\S)
         (display (string-set! xx 0 #\B))
         (display xx)
	 (write-file "byron.txt"
		     "She walks in beaty, like the night\\n")
	 (set! zz (read-file "byron.txt"))
         (display (substr xx 8 3))
         (display (string-length xx))
	 (display (read-from-string str))
         (display zz)))
