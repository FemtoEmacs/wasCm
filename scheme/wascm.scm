(module web (main start))


(define defs '())

(define (start args)
  (cond [ (null? (cdr args))
	  (display "Usage: ./wascm.x file-without-extension")
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

(define (function-heads xs)
  (let loop [(s xs) (acc '())]
    (cond [(null? s) acc]
	  [ (and (pair? s)
		(pair? (car s))
		(equal? (car (car s)) ;; first element of s
			'define)      ;; is a definition
		(pair? (cdr (car s))) ;; thing defined exists
		(pair? (cadr (car s))) ;; and is a list
                (symbol? (car (cadr (car s))) ) ;; defined function
	     );; definition is well formed
	   (let* [(def (car s))
		  (hd (cadr def))
		  (args (cdr hd))
		  (nargs (length args))
		  (arity (cons (car hd) nargs))
		  (body (cddr def))]
	     (when (not (pair? body))
	       (error "Empty definition not allowed"
		      "Culprit" def))
	     (print (format "define - ~a" arity))
	     (loop (cdr s) (cons arity acc)))]
	  [(pair? s)
	   (print (format "declaration - ~a" (car s)))
	   (loop (cdr s) acc)]
	  [else (error "Wrong file format" "Culprit" s)])))

		       
			     
(define (compile-file filename)
  (let* ([i (open-input-file (string-append filename ".web"))]
         [f (string-append filename ".wat")]
         [o (open-output-file f)]
         [src (read i)])
    (set! defs (function-heads src))
    (pp defs)
    (multiple-value-bind (c env) (compile src (list))
      (pp c o)
      (newline o) (newline o)
      (close-output-port o))))

(define (compile d env)
  (match-case d
     [(? number?) (compile-number d env)]
     [(? symbol?) (compile-symbol d env)]
     [(+fx ?l ?r) (compile-add 'i32.add l r env)]
     [(-fx ?l ?r) (compile-minus 'i32.sub l r env)]
     [(*fx ?l ?r) (compile-multiply 'i32.mul l r env)]
     [(/fx ?l ?r) (compile-divide 'i32.div_s l r env)]
     [(rem ?l ?r) (compile-rem 'i32.rem_s l r env)] 
     [(+ ?l ?r) (compile-add 'f64.add l r env)]
     [(- ?l ?r) (compile-minus 'f64.sub l r env)]
     [(* ?l ?r) (compile-multiply 'f64.mul l r env)]
     [(/ ?l ?r) (compile-divide 'f64.div l r env)]
     [(=fx ?l ?r) (compile-equal 'i32.eq l r env)]
     [(/=fx ?l ?r) (compile-unequal 'i32.ne l r env)]
     [(>fx ?l ?r) (compile-greater 'i32.gt_s l r env)]
     [(>=fx ?l ?r) (compile-greater-equal 'i32.ge_s l r env)]
     [(<fx ?l ?r) (compile-less 'i32.lt_s l r env)]
     [(<=fx ?l ?r) (compile-less-equal 'i32.le_s l r env)]
     [(= ?l ?r) (compile-equal 'f64.eq l r env)]
     [(/= ?l ?r) (compile-unequal 'f64.ne l r env)]
     [(> ?l ?r) (compile-greater 'f64.gt l r env)]
     [(>= ?l ?r) (compile-greater-equal 'f64.ge l r env)]
     [(< ?l ?r) (compile-less 'f64.lt l r env)]
     [(<= ?l ?r) (compile-less-equal 'f64.le l r env)]
     [(define (?name . ?params) if . ?body)
      (compile-tre name params (cons 'if body) '())]
     [(define (?name . ?params) . ?body)
       (compile-define name params body '())]
     [ (if ?cond ?exp1 ?exp2)
       (compile-if-then-else '(result i32)
		     cond exp1 exp2 env)]
     [ (if.x ?cond ?exp1 ?exp2)
       (compile-if-then-else '(result f64)
		      cond exp1 exp2 env)]
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
     [(data ?mempos ?maxsize . ?body)
      (compile-data mempos maxsize body)]
     [(module . ?body ) (compile-module body env)]
     [(?name . ?params)
      (when (not (member (cons name (length params)) defs))
	(error "function call not defined "
	       "culprit" (cons name params)))
      (compile-call name params env)] ))


(define (gconst x)
  (if (and (integer? x) (exact? x)) 'i32.const 'f64.const))

(define (compile-number n env)
  (values `(,(gconst n) ,n) env))

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

(define (str x) (prefix (symbol->string x)))

(define (compile-add sum l r env)
    (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
         (values `(,sum ,l ,r) env)) ))

(define (compile-minus sub l r env)
    (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
    (values `(,sub ,l ,r) env)) ))

(define (compile-multiply mul l r env)
    (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
    (values `(,mul ,l ,r) env)) ))

(define (compile-divide div l r env)
     (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
  (values `(,div ,l ,r) env)) ))

(define (compile-rem rem l r env)
     (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
  (values `(,rem ,l ,r) env)) ))


(define (compile-equal pred l r env)
      (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
  (values `(,pred ,l ,r) env)) ))

(define (compile-unequal pred l r env)
      (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
  (values `(,pred ,l ,r) env)) ))

(define (compile-greater pred l r env)
      (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
  (values `(,pred ,l ,r) env)) ))

(define (compile-greater-equal pred l r env)
      (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
  (values `(,pred ,l ,r) env)) ))

(define (compile-less pred l r env)
      (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env)
  (values `(,pred ,l ,r) env)) ))

(define (compile-less-equal pred l r env)
    (multiple-value-bind (l env) (compile l env)
      (multiple-value-bind (r env) (compile r env) 
    (values `(,pred ,l ,r) env)) ))

(define (compile* exps env)
  (let nxt [(s exps) (e env) (result '())]
    (if  (null? s)
         (values (reverse result) e)
	 (multiple-value-bind (exp e)
	    (compile (car s) e)
	    (nxt (cdr s) e
	       (cons exp result))) )))

(define (flres? x)
  (let [(sfx (suffix (symbol->string x)))]
    (or (string=? sfx "x")
	(string=? sfx "y"))))

(define (gr x)
  (if (flres? x) 'f64 'i32))

;;      (compile-tre name params (cons 'if body) '())]

(define (compile-tre name ps body env)
     (let* [ (params (apply append
		       (map (lambda (p)
			      `((param ,($ p) ,(gr p) ))) ps)))]
       (values `((func ,($ name) ,@params (result ,(gr name))
		      (local $res ,(gr name))
		      (block $exit
			 (loop $tre
			       ,@(compile-tre* name ps body env)))
		      (get_local $res))
		 (export ,(str name) (func ,($ name))))
	  env)))

(define (setthem xs env)
  (map (lambda (p) `(local.set ,($ p))) xs))

(define (compile-tre* name ps body env)
  (define (tre? x) (equal? name x))
  (match-case body
    [ (((? tre?) . ?args))
       `((block
	  ,@(map (lambda(p) (compile p env)) (reverse args))
	  ,@(setthem ps env) (br $tre)))]
     [ (if ?pred ((? tre?) . ?args) . ?rest)		
       `((br_if $tre ,(compile pred env)
	    (block
	     ,@(map (lambda(p) (compile p env))
		    (reverse args))
	     ,@(setthem ps env) (br $tre)))
	 ,@(compile-tre* name ps rest env))]
     [ (if ?pred ?retexpr . ?resto) 
       `((br_if $exit ,(compile pred env)
		(local.set $res ,(compile retexpr env)))
	 ,@(compile-tre* name ps resto env))]
     [?other (print other)  '(())  ]))

(define (compile-define name ps body env)
  (multiple-value-bind (body env) (compile* body env)
    (let* ( (params (apply append
		       (map (lambda (p)
			      `((param ,($ p) ,(gr p) ))) ps)))
            (locals (apply append
		       (map (lambda (name)
			      `((local ,($ name) i32))) env)) ))
      (values `((func ,($ name) ,@params (result ,(gr name))
		      ,@locals ,@body)
		(export ,(str name)
			(func ,($ name)))) env)) ))

(define (compile-if-then-else typ cond exp1 exp2 env)
  (multiple-value-bind (cond env) (compile cond env)
  (multiple-value-bind (exp1 env) (compile exp1 env)
  (multiple-value-bind (exp2 env) (compile exp2 env)
     (values `(if ,typ ,cond (then ,exp1)
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

(define (compile-data mempos maxsize body)
  `(,@(compila-data-declaration mempos maxsize body)
    ,(compila-data-initialize mempos maxsize body)
    (export "initstr" (func $initstr))
    ,@(compile-pos mempos maxsize)))

(define (compila-data-declaration mempos maxsize body)
  (let loop [(pos mempos) (s body) (acc '())]
    (cond [(null? s) (reverse acc)]
	  [(string? (car s))
	   (loop (+ pos maxsize) (cdr s)
		 (cons `(data (i32.const ,(+ pos 4)) ,(car s)) acc))]
	  [else (error "in data section" body (car s))])))

(define (compila-data-initialize mempos maxsize body)
  (let loop [(pos mempos) (s body) (acc '()) ]
	(cond [(null? s) `(func $initstr (result) ,@(reverse acc))]
	      [(string? (car s))
	       (loop (+ pos maxsize)
		     (cdr s)
		     (cons `(i32.store (i32.const ,pos)
				       (i32.const ,(string-length (car s)) ))
			   acc))]
	      [else (error "in data section" body (car s))])))
	      
(define (compile-pos mempos maxsize)
  `( (func $pos (param $n i32) (result i32)
	   (i32.add (i32.const ,mempos)
	      (i32.mul (local.get $n) (i32.const ,maxsize)) ))
     (export "pos" (func $pos))
     (func $getsz (param $n i32) (result i32)
	   (i32.load (call $pos (local.get $n) ) ) )
     (export "getsize" (func $getsz)) ))
