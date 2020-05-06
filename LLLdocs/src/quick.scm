;; File: quicksort.scm

;; Output: elements of xs that are smaller than p

(define (smaller xs p)
  (cond [ (null? xs) xs]
     [ (< (car xs) p)
       (cons (car xs)
            (smaller (cdr xs) p))]
     [else (smaller (cdr xs) p)] ))


;; Output: elements of xs greater or equal to p

(define (greater xs p)
  (cond [ (null? xs) xs]
        [ (>= (car xs) p)
          (cons (car xs)
            (greater (cdr xs) p))]
        [else (greater (cdr xs) p)] )) 

(define (quick s)
  (cond [ (null? s) s]
        [ (null? (cdr s)) s]
        [else (append 
                 (quick (smaller (cdr s) (car s)))
                    (list (car s))
                 (quick (greater (cdr s)
                                  (car s))) )] ))

#|
1:=> (load "quick.scm")
quick.scm
1:=> (quick '(8 4 6 3 9 3))
(3 3 4 6 8 9)
|#
