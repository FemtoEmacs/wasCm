;; Compiled with guile
(letrec [ (fn (lambda(x y) (*fx x x y y)))
          (str "Rose")
          (chr #\c)
          (cns '(3 4 5))
          (n 42)
          (fl 42.0)]
  (display (string? str))
  (display (char? chr))
  (display (pair? cns))
  (display (integer? n))
  (display (float? fl))
  (display (fn 3 9)) )

