;; Compiled with guile

(define str "Rose")

(define (floop env ix fy)
      (if (< ix 1) fy
          (floop env (- ix 1) (+ fy 0.1)) ))

(define (fadd env fx fy)
     (+ fx fy))

(define (fn x y) (*fx x x y y))

(letrec [ (chr #\c)
          (cns '(3 4 5))
          (n 42)
          (fl 42.0)]
  (display (floop 1000000 0.0))
  (display (string? str))
  (display (char? chr))
  (display (pair? cns))
  (display (integer? n))
  (display (float? fl))
  (display (fn 3 9)) )

