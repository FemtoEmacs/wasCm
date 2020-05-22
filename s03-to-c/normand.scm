
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


(define-syntax OR 
  (syntax-rules () 
     [(OR x y) (if x x y)]
     [(OR x y z ...) (if x x (OR y z ...))]))

(define-syntax &&
  (syntax-rules ()
    [(&& x) x]
    [(&& x y) (if x y #f)]
    [(&& x y z ...) (if x y (&& z ...))]))

(define (normand a)
  (cond [(not (pair? a)) a]
        [(equal? (car a) '&&) (expand a)]
        [(equal? (car a) 'OR)
         (expand a)]
        [else (map normand a)]))








