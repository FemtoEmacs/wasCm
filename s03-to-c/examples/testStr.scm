(letrec [(xx "Rose of Luxemburg")
         (yy "Anna Bolena")]
  (begin (display (string-ref xx 0))
         (display (string-ref xx 1))
         (display (strcat xx yy))
         (display #\S)
         (display (string-set! xx 0 #\B))
         (display xx)
         (display (substr xx 8 3))
         (display (string-length xx))
         (display (substr xx 8 10))
         (display (string-ref xx 42))
         (display "It should not reach this point")))



