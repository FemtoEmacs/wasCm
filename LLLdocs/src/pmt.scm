;; File: pmt.scm

(define (pmt 
         p ;; present value
         i ;; interest 
         n ;; number of periods
         ;; optional parameters
         #!optional    (r (/ i 100.0)) 
              (rn (expt (+ 1.0 r) n)) );;end of parameter list
(/ (* r p rn)
   (- rn 1))
);;end of define

