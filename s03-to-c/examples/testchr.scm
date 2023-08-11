;; Test all char predicates
(letrec [(xx "Rose of Luxembourg")]
  (display (if (char>? (string-ref xx 2) #\r) 42 43))
  (display (if (char>? (string-ref xx 2) #\t) 42 43))
  (display (if (char=? (string-ref xx 2) #\s) 42 43))
  (display (if (char=? (string-ref xx 2) #\z) 42 "not equal"))
  (display (if (char<? (string-ref xx 2) #\s) 42 43))
  (display (if (char<? (string-ref xx 2) #\z) 42 "not equal"))
  (display (if (char<=? (string-ref xx 2) #\s) 42 43))
  (display (if (char<=? (string-ref xx 2) #\z) 42 "not equal"))
  (display (if (char>=? (string-ref xx 2) #\s) 42 43))
  (display (if (char>=? (string-ref xx 2) #\z) 42 "not equal"))
  (display (if (char~=? (string-ref xx 2) #\s) 42 43))
  (display (if (char~=? (string-ref xx 2) #\z) 42 "not equal"))

  )
