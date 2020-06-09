;; Test quote
(letrec
    [(xx 42)]
  (display '(xx 42 "found:" (80 90 "and also" 45.7) 56)))
