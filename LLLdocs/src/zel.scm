(define (zeller y m day)
  (let* [ (roman-month (if (< m 3) (+ m 10) (- m 2)))
        (roman-year (if (< m 3) (- y 1) y))
        (century (quotient roman-year 100))
        (decade (remainder roman-year 100))]
    (remainder (+ day decade
         (quotient (- (* 13 roman-month) 1) 5)
         (quotient decade 4)
         (quotient century 4)
         (* century -2)) 7)) )
