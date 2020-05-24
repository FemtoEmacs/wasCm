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

;; OjO =====================
(define (rdcode file-name)
   (call-with-input-file file-name
    (lambda(ip)
      (let loop [(r (read ip)) (acc '())]
        (cond [(eof-object? r) acc]
              [else (loop (read ip) (cons r acc))])) )))

(define (insDef fcontents)
  (define (isdef? s)
    (or (and (pair? s) (equal? (car s) 'define)
           (pair? (cdr s)) (pair? (cadr s))
           (pair? (cdr (cadr s))) 
           (not (equal? (cadr (cadr s)) 'env)))
        (and (pair? s) (equal? (car s) 'define)
             (pair? (cdr s)) (symbol? (cadr s)))))
  (define (maybetail? s)
    (and (pair? s) (equal? (car s) 'define)
         (pair? (cdr s)) (pair? (cadr s))
         (pair? (cdr (cadr s))) (equal? (cadr (cadr s)) 'env)))
  (define (normalize def)
    (cond [(symbol? (cadr def)) (cdr def)]
          [else `(,(car (cadr def)) (lambda ,(cdr (cadr def))
                                      ,@(cddr def)))]))
  (let* [ (lrec (car fcontents))
          (lrec (cond [ (not (pair? lrec))
                        `(letrec [()] ,lrec)]
                      [(not (equal? (car lrec) 'letrec))
                          `(letrec [()] ,lrec)]
                      [else lrec]))
          (ldefs (cadr lrec))
          (lbody (cddr lrec))
          (tail (filter maybetail?  (cdr fcontents)))
          (defs (map normalize (filter isdef? (cdr fcontents))))
          (lrec `(letrec [,@defs ,@ldefs] ,@lbody))
          (lrec (if (equal? '(()) (cadr lrec)) (caddr lrec) lrec)) ]
    `(,lrec ,@tail)  ))

;; End of Ojo ===============

