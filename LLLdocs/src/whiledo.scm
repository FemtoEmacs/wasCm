(define-syntax while-do 
  (syntax-rules ()
    [ (kwd condition the-return  bdy ...)
      (do () ((not condition) the-return) bdy ...)]))

(define (reverse-iota m)
  (let [(s '()) (i 0)]
    (while-do (< i m) s
	    (set! s (cons i s))
	    (set! i (+ i 1)) )))
#|
1:=> (load "whiledo.scm")
whiledo.scm
1:=> (reverse-iota 5)
(4 3 2 1 0)
|#
