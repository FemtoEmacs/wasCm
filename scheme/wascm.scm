(module web (main start))

(define (start args)
  (cond [ (null? (cdr args))
	  (display "Usage: ./newcomp file-without-extension")
	  (newline)]
	[ (file-exists? (format "~a.web" (cadr args)))
	  (compile-file (cadr args))
	  (newline)]
	[ (and (file-exists? (cadr args))
	       (equal? (suffix (cadr args)) "web"))
	  (compile-file (prefix (cadr args)))
	  (newline)]
	[else (display "Type the file name without extension")
	      (newline)]))

(define (compile-file filename)
  (let* ([i (open-input-file (string-append filename ".web"))]
         [f (string-append filename ".wat")]
         [o (open-output-file f)]
         [src (read i)])
    (write src)
    (multiple-value-bind (c env) (compile src (list))
      (write c o)
      (newline o) (newline o)
      (close-output-port o))))

(define (compile d env)
  (match-case d
     [(? number?) (compile-number d env)]
     [(? symbol?) (compile-symbol d env)]
     [(fx+ ?l ?r) (compile-add l r env)]
     [(fx- ?l ?r) (compile-minus l r env)]
     [(fx* ?l ?r) (compile-multiply l r env)]
     [(fx/ ?l ?r) (compile-divide l r env)]
     [(fx= ?l ?r) (compile-equal l r env)]
     [(fx/= ?l ?r) (compile-unequal l r env)]
     [(fx> ?l ?r) (compile-greater l r env)]
     [(fx>= ?l ?r) (compile-greater-equal l r env)]
     [(fx< ?l ?r) (compile-less l r env)]
     [(fx<= ?l ?r) (compile-less-equal l r env)]
     [(define (?name . ?params) . ?body)
       (compile-define name params body '())]
     [(if ?cond ?exp1 ?exp2) (compile-if-then-else cond exp1 exp2 env)]
     [(local [?name ?exp] . ?body)
      (compile-local name exp body env)]
     [(let ?vars . ?body)
      (compile-let vars body env)]
     [(ref32 ?index)
      (compile-ref32 index env)]
     [(set! ?ind ?v)
      (compile-set ind v env)]
     [(mem ?pages)
      (compile-mem pages env)]
     [(module . ?body ) (compile-module body env)]
     [(?name . ?params) (compile-call name params env)] ))
 
(define (compile-number n env)
  (values `(i32.const ,n) env))

(define (compile-symbol s env)
  (values `(get_local ,($ s)) env))

(define (compile-ref32 indx env)
  (multiple-value-bind (i env) (compile indx env)
    (values `(i32.load (i32.mul  ,i (i32.const 4)))
	env)))

(define (compile-mem pages env)
  (cond [ (integer? pages)
	  `((memory $mem 1 ,pages)
            (export "mem" (memory $mem)))]
	[else (error "mem" "check memory declaration" 43)]))

(define (compile-set jdx val env)
  (multiple-value-bind (j env) (compile jdx env)
    (multiple-value-bind (v env) (compile val env)
      (values  `(i32.store  (i32.mul ,j  (i32.const 4)) ,v) env)) ))

(define ($ x)
  (string->symbol (string-append "$" (symbol->string x))))

(define (str x) (symbol->string x))

(define (compile-add l r env)
    (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
         (values `(i32.add ,l ,r) env)) ))

(define (compile-minus l r env)
    (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
    (values `(i32.sub ,l ,r) env)) ))

(define (compile-multiply l r env)
    (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
    (values `(i32.mul ,l ,r) env)) ))

(define (compile-divide l r env)
     (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
  (values `(i32.div ,l ,r) env)) ))

(define (compile-equal l r env)
      (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
  (values `(i32.eq ,l ,r) env)) ))

(define (compile-unequal l r env)
      (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
  (values `(i32.ne ,l ,r) env)) ))

(define (compile-greater l r env)
      (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
  (values `(i32.gt_s ,l ,r) env)) ))

(define (compile-greater-equal l r env)
      (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
  (values `(i32.ge_s ,l ,r) env)) ))

(define (compile-less l r env)
      (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
  (values `(i32.lt_s ,l ,r) env)) ))

(define (compile-less-equal l r env)
    (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env) 
    (values `(i32.le_s ,l ,r) env)) ))

(define (compile* exps env)
  (let nxt [(s exps) (e env) (result '())]
    (if  (null? s)
         (values (reverse result) e)
	 (multiple-value-bind (exp e)
	    (compile (car s) e)
	    (nxt (cdr s) e
	       (cons exp result))) )))

(define (compile-define name ps body env)
  (multiple-value-bind (body env) (compile* body env)
    (let* ( (params (apply append
		       (map (lambda (p) `((param ,($ p) i32))) ps)))
            (locals (apply append
		       (map (lambda (name)
			      `((local ,($ name) i32))) env)) ))
      (values `((func ,($ name) ,@params (result i32)
		      ,@locals ,@body)
		(export ,(str name)
			(func ,($ name)))) env)) ))

(define (compile-if-then-else cond exp1 exp2 env)
  (multiple-value-bind (cond env) (compile cond env)
  (multiple-value-bind (exp1 env) (compile exp1 env)
  (multiple-value-bind (exp2 env) (compile exp2 env)
     (values `(if (result i32) ,cond (then ,exp1)
		  (else ,exp2)) env)) )))

(define (compile-call name params env)
  (multiple-value-bind (params env) (compile* params env)
    (values `(call ,($ name) ,@params) env)) )

(define (compile-module body env)
  (multiple-value-bind (body env) (compile* body env)
    (let [(body  (apply append body))]
       (values `(module  ,@body) env))))

(define (compile-local name exp body env)
  (multiple-value-bind (exp env) (compile exp env)
   (multiple-value-bind (body env) (compile* body env)
     (let* [(body (apply append body))
            (env (cons name env))]
       (values `(block (result i32)
		   (set_local ,($ name) ,exp) ,body) env)) )))

(define (compile-let vx body env)
  (let ((exps (map (lambda(e)
		     `(set_local ,($ (car e))
			,(compile (cadr e) env))) vx))
	(newenv  (append (map car vx) env)))
   (multiple-value-bind (body env) (compile* body newenv )
     (let [(body (apply append body))]
       (values `(block (result i32) ,@exps ,body) env)) )))
