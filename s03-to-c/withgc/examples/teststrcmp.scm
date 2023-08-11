;; Test string predicates
(letrec [(xx "Rose")
         (zz "Rose")
         (yy "Hippatia")]
  (display (string=? xx zz))
  (display (string=? xx yy))
  (display (string>? xx yy))
  (display (string<? xx yy))
  (display (string>? yy xx))
  (display (string<? yy xx)))

