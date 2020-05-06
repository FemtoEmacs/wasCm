(define (winter m)
   (quotient (- 14 m) 12))

(define (roman-order m)
   (+ m (* (winter m) 12) -2))

(define (zr y m day)
  (let* ( (roman-month (roman-order m))
      (roman-year (- y (winter m)))
      (century (quotient roman-year 100))
      (decade (remainder roman-year 100)) )
   (remainder(+ day
               (quotient (- (* 13 roman-month) 1) 5)
               decade
               (quotient decade 4)
               (quotient century 4)
               (* century -2)) 7)) )
