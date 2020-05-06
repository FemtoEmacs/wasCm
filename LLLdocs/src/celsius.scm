; File: celsius.scm

(define (c2f x)
(- (/ (* (+ x 40) 9) 5.0) 40)
);;end define

(define (f2c x)
(- (/ (* (+ x 40) 5.0) 9) 40)
);;end define
