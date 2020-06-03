(define this-scheme 'bigloo)
(define (defprim-error procedure msg info)
  (cond
   [ (equal? this-scheme 'bigloo)
     (error procedure (format msg (car info)) "in Bigloo")]
    [ (equal? this-scheme 'racket)
          (error 'misc-error "~a --  ~a"
                 procedure (format msg (car info)) )]
    [ (equal? this-scheme 'guile)
     (error "Error message: " procedure
        (format #f msg  (format #f "~{~a~}" info)))]
   [else (error "Unsuported Scheme!")]))

(define (cexpand s)
  (define (expandclauses c)
    (cond [(null? c) c]
          [(not (pair? c))
           (defprim-error 'cond-expand
	     "Malformed cond -- ~a!" (list s))]
	  [ (and (pair? (car c))
	        (equal? (caar c) 'else)
		(= (length (car c)) 2))
	     (cexpand (cadar c))]
	  [ (and (pair? (car c))
	        (equal? (caar c) 'else)
		(> (length (car c)) 2))
	   `(begin ,@(map cexpand (cdr (car c))))]
	  [(and (pair? (car c))
		(equal? (caar c) 'else))
	   (defprim-error 'cond-expand
	     "Clauses after else -- ~a" (list s))]
	  [(and (pair? (cdr c)) 
		(= (length (car c)) 2))
	   `(if ,(cexpand (caar c))
		,(cexpand (car (cdr (car c))))
		,(expandclauses (cdr c)))]
	  [(and (pair? (cdr c))
		(> (length (car c)) 2))
	   `(if ,(cexpand (caar c))
		(begin ,@(map cexpand (cdr (car c))))
		,(expandclauses (cdr c)))]
	  [else (defprim-error 'cond-expand
		  "Malformed cond -- ~a" (list c))]))
		       
  (cond [(not (pair? s)) s]
        [(equal? (car s) 'cond)
         (expandclauses (cdr s))]
        [else (cons (cexpand (car s))
                    (cexpand (cdr s)))]))

