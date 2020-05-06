;; File: fvalue.scm

(define  (future-value pv i n)
(* (expt (+ (/ i 100.0) 1) n) 
   pv)
);;end define
