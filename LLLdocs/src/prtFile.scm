(define (port->lines p)
   (let next-line ( (i 1) (x (read-line p)) )
     (cond [ (eof-object? x) #t]
	[ (< (string-length x) 1)]
	[ (char=? (string-ref x 0) #\;)]
        [else (display "#| ")
              (display (number->string i))
              (cond [ (< i 10)  (display "  |# ")]
                    [else  (display " |# ")])
              (display x) (newline)
              (next-line (+ i 1) (read-line p))] ))) 

(define (rdLines filename)
   (call-with-input-file filename port->lines))

;; 1:=> (load "prtFile.scm")
;; prtFile.scm
;; 1:=> (rdLines "average.scm")
;; #| 1  |# (define (avg xs)
;; #| 2  |#    (let nxt [(s xs) (acc 0) (n 0)]
;; #| 3  |#      (cond [ (and (null? s) (= n 0)) 0]
;; #| 4  |#          [ (null? s) (/ acc n) ]
;; #| 5  |#          [else (nxt (cdr s) (+ (car s) acc)
;; #| 6  |#                   (+ n 1.0))] )))
