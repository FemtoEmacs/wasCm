;; A scm2c compiler.

;; Bigloo: Program should work as it is

;; Racket: Uncomment the line below
;; #lang racket

(define-syntax fmt
(syntax-rules ()
  [ (fmt fstr arg ...) 
    (format 
;; Guile: Uncomment the line below.
;;    #f
    fstr arg ...)]))

;; Leave your brand of scheme uncommented
(define this-scheme 'bigloo)
;; (define this-scheme 'guile)
;; (define this-scheme 'racket)

;; The compiler is basically the one proposed
;; by Matthew Might is his blog:

;; Author: Matthew Might
;; Site:   http://matt.might.net/
;;         http://www.ucombinator.org/

;; The purpose of this compiler is to demonstrate
;; the most direct possible mapping of Scheme into C.
;; Toward that end, the compiler uses only two
;; intermediate transformations: mutable-variable
;; elimination and closure-conversion.

;; To run the compiler, enter your favorite scheme
;; and execute the command below:

;;  > (compit "test2.scm"  "test2.c")

;; where "test2.scm" is the input file, in scheme,
;; and "test2.c" is the output file. To  compile
;; the C program, type the shell command below.

;;  $ emcc test2.c -o test2.js

;; To execute the program, type:

;; $ node test2.js


;; The compiler handles Core Scheme and some extras.
;; With a macro system like syntax-rules and some
;; more primitives, all of R5RS could be supported.

;; Unlike the Java version, this compiler handles
;; recursion using a lets+sets transformation.

;; The compilation proceeds from Core Scheme plus
;; sugar through three intermediate languages:

;; Core Scheme + Sugar

;;    =[desugar]=>

;; Core Scheme 

;;    =[mutable variable elimination]=>

;; Intermediate Scheme (1) 

;;    =[closure conversion]=>

;; Intermediate Scheme (2) 

;;    =[code emission]=>

;; C


;; Core input language:

;; <exp> ::= <const>
;;        |  <prim>
;;        |  <var>
;;        |  (lambda (<var> ...) <exp>)
;;        |  (if <exp> <exp> <exp>)
;;        |  (set! <var> <exp>)
;;        |  (<exp> <exp> ...)

;; <const> ::= <int>
;;          |  #f 

;; Syntactic sugar:

;; <exp> ::+ (let ((<var> <exp>) ...) <exp>)
;;        |  (letrec ((<var> <exp>) ...) <exp>)
;;        |  (begin <exp> ...)

;; Intermediate language (1)

;; <exp> ::+ (cell <exp>)
;;        |  (cell-get <exp>)
;;        |  (set-cell! <exp> <value>)

;; Intermediate language (2)

;; <exp> ::+ (closure <lambda-exp> <env-exp>)
;;        |  (env-make <env-num> (<symbol> <exp>) ...)
;;        |  (env-get <env-num> <symbol> <exp>)

;; To add new primitives, follow the commented tag
;; plusprimitives placed on lines of the form:

;; plusprimitives

;; Then, follow the examples below this comment line.


;; Utilities.

; void : -> void
(define (void) (if #f #t #f))

; tagged-list? : symbol value -> boolean
(define (tagged-list? tag l)
  (and (pair? l)
       (eq? tag (car l))))

; char->natural : char -> natural
(define (char->natural c)
  (let ((i (char->integer c)))
    (if (< i 0)
        (* -2 i)
        (+ (* 2 i) 1))))

; integer->char-list : integer -> string
(define (integer->char-list n)
  (string->list (number->string n)))


;; gensym-count : integer
(define gensym-count 0)

; gensym : symbol -> symbol
(define gsym (lambda params
                 (if (null? params)
                     (begin
                       (set! gensym-count (+ gensym-count 1))
                       (string->symbol (string-append
                                        "$"
                                        (number->string gensym-count))))
                     (begin
                       (set! gensym-count (+ gensym-count 1))
                       (string->symbol (string-append 
                                        (if (symbol? (car params))
                                            (symbol->string (car params))
                                            (car params))
                                        "$"
                                        (number->string gensym-count)))))))


; smember : symbol sorted-set[symbol] -> boolean
(define (smember sym S)
  (if (not (pair? S))
      #f
      (if (eq? sym (car S))
          #t
          (smember sym (cdr S)))))

; symbol<? : symbol symobl -> boolean
(define (symbol<? sym1 sym2)
  (string<? (symbol->string sym1)
            (symbol->string sym2)))

; insert : symbol sorted-set[symbol] -> sorted-set[symbol]
(define (insert sym S)
  (if (not (pair? S))
      (list sym)
      (cond
        ((eq? sym (car S))       S)
        ((symbol<? sym (car S))  (cons sym S))
        (else (cons (car S) (insert sym (cdr S)))))))

; remove : symbol sorted-set[symbol] -> sorted-set[symbol]
(define (remove sym S)
  (if (not (pair? S))
      '()
      (if (eq? (car S) sym)
          (cdr S)
          (cons (car S) (remove sym (cdr S))))))
          
; union : sorted-set[symbol] sorted-set[symbol] -> sorted-set[symbol]
(define (union set1 set2)
  ; NOTE: This should be implemented as merge for efficiency.
  (if (not (pair? set1))
      set2
      (insert (car set1) (union (cdr set1) set2))))

; difference : sorted-set[symbol] sorted-set[symbol] -> sorted-set[symbol]
(define (difference set1 set2)
  ; NOTE: This can be similarly optimized.
  (if (not (pair? set2))
      set1
      (difference (remove (car set2) set1) (cdr set2))))

; sreduce : (A A -> A) list[A] A -> A
(define (sreduce f lst init)
  (if (not (pair? lst))
      init
      (sreduce f (cdr lst) (f (car lst) init))))

; azip : list[A] list[B] -> alist[A,B]
(define (azip list1 list2)
  (if (and (pair? list1) (pair? list2))
      (cons (list (car list1) (car list2))
            (azip (cdr list1) (cdr list2)))
      '()))

; assq-remove-key : alist[A,B] A -> alist[A,B]
(define (assq-remove-key env key)
  (if (not (pair? env))
      '()
      (if (eq? (car (car env)) key)
          (assq-remove-key (cdr env) key)
          (cons (car env) (assq-remove-key (cdr env) key)))))

; assq-remove-keys : alist[A,B] list[A] -> alist[A,B]
(define (assq-remove-keys env keys)
  (if (not (pair? keys))
      env
      (assq-remove-keys (assq-remove-key env (car keys)) (cdr keys))))


;; Define primitives


(define (strapp s)
  (cond [(null? s) ""]
        [(null? (cdr s))
         (fmt "~a" (car s))]
        [else
          (string-append (fmt "~a" (car s))
               (strapp (cdr s)))]))
(define (str-app . s) (strapp s))

;; Error messages must follow the pattern:
;; (defprim-error 'well-formed
;;      "Shape error -- ~a!" (list 42))
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

 
;;An example of primitive:
(define def '())

(define topenv '())
;;  (map (lambda(x)  (car (cadr x))) def))

;; Verify whether s has shape:
;; (define (div x y ...) cmd ...)
(define (wellformed? s)
  (and (pair? s)
       (equal? (car s) 'define)
       (pair? (cdr s))
       (pair? (cadr s))
       (symbol? (caadr s))
       (pair? (cddr s))
       (pair? (caddr s)) )) 

(define (value-declaration s)
  (cond [ (wellformed? s)
	        (str-app "Value __" (caadr s) " ;\n")]
	[else (defprim-error 'value-declaration
	             "Shape error -- ~a!" (list s)  )]))

(define (make-args s)
  (cond [ (wellformed? s)
          (str-app "Value __prim_" (symbol->string (caadr s)) "("
             (let loop ((args (cdadr s)) (str ""))
               (cond [(null? args) str]
                     [(null? (cdr args))
                      (str-app str "Value " (symbol->string (car args)))]
                     [else (loop (cdr args)
                              (str-app str "Value " 
                                (symbol->string (car args)) "," ))]))
               "){\n")]
	[else (defprim-error 'value-declaration
	             "Shape error -- ~a!" (list s) )]))
  
(define (make-scheme-arg var)
  (let [(s (symbol->string var))]
    (cond
      [ (and (char>? (string-ref s 0) #\e)
             (char<? (string-ref s 0) #\i))
            (str-app s ".f.value")]
	    [ (and (char>? (string-ref s 0) #\h)
             (char<? (string-ref s 0) #\l))
            (str-app s ".z.value")]
      [ (or (and (char>=? (string-ref s 0) #\a)
               (char<? (string-ref s 0) #\f))
          (and (char>? (string-ref s 0) #\k)
               (char<=? (string-ref s 0) #\z)))
          (str-app  s )]
	  [else (defprim-error 'make-scheme-arg
	     "Illegal var name -- ~a!" (list var)  )] )))

(define (scheme-args vs)
  (map make-scheme-arg vs))

(define (make-called-fun fn)
  (let [(s (symbol->string fn))]
    (cond
       [ (or (and (char>=? (string-ref s 0) #\a)
                  (char<? (string-ref s 0) #\f))
             (and (char>? (string-ref s 0) #\k)
                  (char<=? (string-ref s 0) #\z)))
         (str-app "return (" s)]
       [ (and (char>? (string-ref s 0) #\e)
              (char<? (string-ref s 0) #\i))
           (str-app "return MakeFloat(" s)]
	     [ (and (char>? (string-ref s 0) #\h)
              (char<? (string-ref s 0) #\l))
           (str-app "return MakeInt(" s)])))

(define (append-with-separator s sep)
  (cond [(null? s) ""]
        [(null? (cdr s)) (car s)]
        [else (str-app (car s) sep
                  (append-with-separator (cdr s) sep))]))

(define (mkcall c)
  (let [(cf (make-called-fun (car c)))
        (sexpr? 
          (equal? (string-ref
                    (symbol->string (car c)) 0) #\s)) ]
    (str-app cf
          "(" (append-with-separator
               (scheme-args (cdr c) ) ", ")
          ")) ;\n")))

(define (scheme-side s)
  (cond [(wellformed? s)
	 (string-append
	  (make-args s)
	  (mkcall (cadr s))
	  "}\n\n")]
	[else (defprim-error 'scheme-side
		"Primitive definition -- ~a!" (list s)  )]))

(define (mkcdecl var)
    (let [(s (symbol->string var))]
    (cond
      [ (and (char>? (string-ref s 0) #\e)
             (char<? (string-ref s 0) #\i))
            (string-append "double " s)]
	    [ (and (char>? (string-ref s 0) #\h)
             (char<? (string-ref s 0) #\l)) 
            (string-append "int " s)]
      [ (or (and (char>=? (string-ref s 0) #\a)
                  (char<? (string-ref s 0) #\e))
            (and (char>? (string-ref s 0) #\k)
                  (char<=? (string-ref s 0) #\z)))
         (string-append "Value " s)]
    [  (char=? (string-ref s 0) #\e)
          (string-append "Value " s)]
	  [else
	    (defprim-error 'make-scheme-arg
	       "Illegal var name -- ~a" (list var) )] )))

(define (cdecls vs)
  (map mkcdecl vs))

(define (fun-id z)
  (let* [ (s (if (wellformed? z)
		(symbol->string (caadr z))
		(defprim-error 'fun-id
		  "Illegal id -- ~a" (list z)  )))
	  (c (string-ref s 0))]
  (cond
    [ (or (and (char>=? c #\a)
               (char<? c #\f))
          (and (char>? c #\k)
               (char<=? c #\z)))
      (string-append "Value " s)]
    [ (and (char>? c #\e)
           (char<? c #\i))
      (string-append "double " s)]
    [ (and (char>? c #\h)
           (char<? c #\l))
      (string-append "int " s)]
    [else (defprim-error 'make-scheme-arg
	       "Illegal var name -- ~a!" (list z))] )))

(define (arith? s)
  (and (pair? s) (symbol? (car s))
           (smember (car s) '(+ - / * % < > <= >=))
	   (pair? (cdr s)) (pair? (cddr s)) ))

(define (ccomp  s env vars)

(define (cco s  vars)
  (cond
        [ (arith? s)
	  (fmt  "(~a ~a ~a)"
		  (cco (cadr s) vars)
		  (car s)
		  (cco (caddr s) vars ))]
	[(and (pair? s)
	      (equal? (car s) 'if)
	      (pair? (cdr s))
	      (pair? (cddr s))
	      (pair? (cdddr s)))
	    (fmt  "~a ? ~a : ~a" (cco (cadr s) vars)
		 (cco (caddr s) vars)
		 (cco (cadddr s) vars) )]
   [(and (pair? s)
         (= (length s) 2)
         (equal? (car s) 'f))
     (str-app "__fl(" (cco (cadr s) vars)  ")")]
   [(and (pair? s)
         (= (length s) 2)
         (equal? (car s) 'i))
     (str-app "__int(" (cco (cadr s) vars)  ")")]
   [(and (pair? s)
         (= (length s) 2)
         (equal? (car s) 'null?))
     (str-app "__isNil(" env "," (cco (cadr s) vars)  ")")]
   [ (and (pair? s) (= (length s) 3) (equal? (car s) 'cons))
     (str-app "__prim_pairCons(" env ", " (cco (cadr s) vars)
           ", "   (cco (caddr s) vars) ")")]
   [ (and (pair? s) (= (length s) 2) (equal? (car s)  'iexpr))
     (str-app "__iexpr(" env ", " (cco (cadr s) vars) ")")]

   [ (and (pair? s) (= (length s) 2) (equal? (car s)  'fexpr))
     (str-app "__fexpr(" env ", " (cco (cadr s) vars) ")")]

   [(and (pair? s)
         (= (length s) 2)
         (equal? (car s) 'car))
    (str-app "__prim_pairCar(" env ", " (cco (cadr s) vars) ")")]
   [(and (pair? s)
         (= (length s) 2)
         (equal? (car s) 'cdr))
    (str-app "__prim_pairCdr(" env ", " (cco (cadr s) vars) ")")]
	 [(and (pair? s)
	      (symbol? (car s)))
          (str-app (car s) "("
              (append-with-separator
               (map (lambda(x) (cco x vars  )) (cdr s)) "," ) ")" )]
	[(smember s vars)
	 (fmt  "~a" s)]
	[(number? s) (fmt  "~a" s)]
	[else (defprim-error 'make-scheme-arg
	        "Illegal cc expr -- ~a!" (list s) )]))	 
  (fmt  "return ~a" (cco s vars)) ))
  
(define (cside s)
  (let* [ (z (if (wellformed? s)
		            (symbol->string (caadr s))
		            (defprim-error 'fun-id
		            "Illegal cside -- ~a" (list s) )))
	        (c (string-ref z 0))
          (sexpr? (equal? c #\s))]
 
  (str-app (fun-id s) "("
     (append-with-separator
       (cdecls  (cdr (cadr s))   ) "," ) "){\n"
     (ccomp  (car (cddr s)) (cadr (cadr s)) (cdr (cadr s)) )
     ";}\n")))
     


;; Data type predicates and accessors.

; const? : exp -> boolean
(define (const? exp)
  (or (and (integer? exp) (exact? exp))
      (and (number? exp) (inexact? exp))
      (string? exp)
      (char? exp)
      (boolean? exp)))

; ref? : exp -> boolean
(define (ref? exp)
  (symbol? exp))

; let? : exp -> boolean
(define (let? exp)
  (tagged-list? 'let exp))

; let->bindings : let-exp -> alist[symbol,exp]
(define (let->bindings exp)
  (cadr exp))

; let->exp : let-exp -> exp
(define (let->exp exp)
  (caddr exp))

; let->bound-vars : let-exp -> list[symbol]
(define (let->bound-vars exp)
  (map car (cadr exp)))

; let->args : let-exp -> list[exp]
(define (let->args exp)
  (map cadr (cadr exp)))

; letrec? : exp -> boolean
(define (letrec? exp)
  (tagged-list? 'letrec exp))

; letrec->bindings : letrec-exp -> alist[symbol,exp]
(define (letrec->bindings exp)
  (cadr exp))

; letrec->exp : letrec-exp -> exp
(define (letrec->exp exp)
  (caddr exp))

; letrec->exp : letrec-exp -> list[symbol]
(define (letrec->bound-vars exp)
  (map car (cadr exp)))

; letrec->exp : letrec-exp -> list[exp]
(define (letrec->args exp)
  (map cadr (cadr exp)))

; lambda? : exp -> boolean
(define (lambda? exp)
  (tagged-list? 'lambda exp))

; lambda->formals : lambda-exp -> list[symbol]
(define (lambda->formals exp)
  (cadr exp))

; lambda->exp : lambda-exp -> exp
(define (lambda->exp exp)
  (caddr exp))

; if? : exp -> boolean
(define (if? exp)
  (tagged-list? 'if exp))

; if->condition : if-exp -> exp
(define (if->condition exp)
  (cadr exp))

; if->then : if-exp -> exp
(define (if->then exp)
  (caddr exp))

; if->else : if-exp -> exp
(define (if->else exp)
  (cadddr exp))

; app? : exp -> boolean
(define (app? exp)
  (pair? exp))

; app->fun : app-exp -> exp
(define (app->fun exp)
  (car exp))

; app->args : app-exp -> list[exp]
(define (app->args exp)
  (cdr exp))


;; plusprimitives
; prim? : exp -> boolean
(define (prim? exp)
  (or   (eq? exp '+fx)
      (eq? exp '-fx)
      (eq? exp '*fx)
      
      (eq? exp '<fx)
      (eq? exp '<=fx)
      (eq? exp '>fx)
      (eq? exp '>=fx)
      (eq? exp '=fx)

      (eq? exp '<)
      (eq? exp '<=)
      (eq? exp '>)
      (eq? exp '>=)
      (eq? exp '=)


      (eq? exp '+)
      (eq? exp '-)
      (eq? exp '*)
      (eq? exp '/)

      (eq? exp 'mod)
      (eq? exp 'quot)
      (eq? exp 'cons)
      (eq? exp 'car)
      (eq? exp 'cdr)
      (eq? exp 'null?)
      (eq? exp 'while)
      (eq? exp 'arg)
      (eq? exp 'string-ref)
      (eq? exp 'string-set!)
      (eq? exp 'string-length)
      (eq? exp 'substr)
      (eq? exp 'char=?)
      (eq? exp 'char>?)
      (eq? exp 'char<?)
      (eq? exp 'char>=?)
      (eq? exp 'char<=?)
      (eq? exp 'char~=?)
      (eq? exp 'string=?)
      (eq? exp 'string>?)
      (eq? exp 'string<?)
      (eq? exp 'strcat)
      (eq? exp 'not)

      (eq? exp 'string?)
      (eq? exp 'char?)
      (eq? exp 'pair?)
      (eq? exp 'integer?)
      (eq? exp 'float?)
      (eq? exp 'read-file)
      (eq? exp 'write-file)
      (eq? exp 'read-from-string)      
      (smember exp topenv)  ;; OjO
      ;;(eq? exp (car (cadr def))) ;; OjO
      (eq? exp 'display)))

; begin? : exp -> boolean
(define (begin? exp) 
  (tagged-list? 'begin exp))

; begin->exps : begin-exp -> list[exp]
(define (begin->exps exp)
  (cdr exp))

; set! : exp -> boolean
(define (set!? exp)
  (tagged-list? 'set! exp))

; set!->var : set!-exp -> var
(define (set!->var exp)
  (cadr exp))

; set!->exp : set!-exp -> exp
(define (set!->exp exp)
  (caddr exp))

; closure? : exp -> boolean
(define (closure? exp) 
  (tagged-list? 'closure exp))

; closure->lam : closure-exp -> exp
(define (closure->lam exp) 
  (cadr exp))

; closure->env : closure-exp -> exp
(define (closure->env exp) 
  (caddr exp))

; env-make? : exp -> boolean
(define (env-make? exp) 
  (tagged-list? 'env-make exp))

; env-make->id : env-make-exp -> env-id
(define (env-make->id exp)
  (cadr exp))

; env-make->fields : env-make-exp -> list[symbol]
(define (env-make->fields exp)
  (map car (cddr exp)))
  
; env-make->values : env-make-exp -> list[exp]
(define (env-make->values exp)
  (map cadr (cddr exp)))

; env-get? : exp -> boolen
(define (env-get? exp)
  (tagged-list? 'env-get exp))

; env-get->id : env-get-exp -> env-id
(define (env-get->id exp)
  (cadr exp))
  
; env-get->field : env-get-exp -> symbol
(define (env-get->field exp)
  (caddr exp))

; env-get->env : env-get-exp -> exp
(define (env-get->env exp)
  (cadddr exp)) 

; set-cell!? : set-cell!-exp -> boolean
(define (set-cell!? exp)
  (tagged-list? 'set-cell! exp))

; set-cell!->cell : set-cell!-exp -> exp
(define (set-cell!->cell exp)
  (cadr exp))

; set-cell!->value : set-cell!-exp -> exp
(define (set-cell!->value exp)
  (caddr exp))

; scell? : exp -> boolean
(define (scell? exp)
  (tagged-list? 'cell exp))

; cell->value : cell-exp -> exp
(define (cell->value exp)
  (cadr exp))

; cell-get? : exp -> boolean
(define (cell-get? exp)
  (tagged-list? 'cell-get exp))

; cell-get->cell : cell-exp -> exp
(define (cell-get->cell exp)
  (cadr exp))



;; Syntax manipulation.

; substitute-var : alist[var,exp] ref-exp -> exp
(define (substitute-var env var)
  (let ((sub (assq var env)))
    (if sub
        (cadr sub)
        var)))



; substitute : alist[var,exp] exp -> exp
(define (substitute env exp)
  
  (define (substitute-with env)
    (lambda (exp)
      (substitute env exp)))

  (cond
    ; Core forms:    
    ((null? env)    exp)
    ((const? exp)   exp)
    ((prim? exp)    exp)
    ((ref? exp)     (substitute-var env exp))
    ((lambda? exp)
     `(lambda ,(lambda->formals exp)
        ,(substitute (assq-remove-keys env (lambda->formals exp)) 
                                        (lambda->exp exp))))
    ((set!? exp)  `(set! ,(substitute-var env (set!->var exp))
                               ,(substitute env (set!->exp exp))))
    ((if? exp)   `(if ,(substitute env (if->condition exp))
                    ,(substitute env (if->then exp))
                    ,(substitute env (if->else exp))))
    
    ; Sugar:
    ((let? exp)  `(let ,(azip (let->bound-vars exp)
                      (map (substitute-with env) (let->args exp)))
                        ,(substitute (assq-remove-keys env 
                                        (let->bound-vars exp))
                                        (let->exp exp))))
    ((letrec? exp)
     (let ((new-env (assq-remove-keys env (letrec->bound-vars exp))))
                          `(letrec ,(azip (letrec->bound-vars exp) 
                                          (map (substitute-with new-env) 
                                               (letrec->args exp)))
                             ,(substitute new-env (letrec->exp exp)))))
    ((begin? exp)       (cons 'begin (map (substitute-with env)
                                          (begin->exps exp))))

    ; IR (1):
    ((scell? exp)        `(cell ,(substitute env (cell->value exp))))
    ((cell-get? exp)    `(cell-get ,(substitute env (cell-get->cell exp))))
    ((set-cell!? exp)   `(set-cell! ,(substitute env (set-cell!->cell exp))
                                    ,(substitute env (set-cell!->value exp))))
    
    ; IR (2):
    ((closure? exp)     `(closure ,(substitute env (closure->lam exp))
                                  ,(substitute env (closure->env exp))))
    ((env-make? exp)    `(env-make ,(env-make->id exp) 
                                   ,@(azip (env-make->fields exp)
                                           (map (substitute-with env)
                                                (env-make->values exp)))))
    ((env-get? exp)     `(env-get ,(env-get->id exp)
                                  ,(env-get->field exp)
                                  ,(substitute env (env-get->env exp))))
    
    ; Application:
    ((app? exp)         (map (substitute-with env) exp))
    (else  (defprim-error 'scheme-error
              "unhandled expression type in substitution: ~a "
               (list exp)  ))))




;; Desugaring.

; let=>lambda : let-exp -> app-exp
(define (let=>lambda exp)
  (if (let? exp)
      (let ((vars (map car (let->bindings exp)))
            (args (map cadr (let->bindings exp))))
        `((lambda (,@vars) ,(let->exp exp)) ,@args))
      exp))

; letrec=>lets+sets : letrec-exp -> exp
(define (letrec=>lets+sets sexp)
  (if (letrec? sexp)
      (let* ((exp (if (> (length sexp) 3)
                      `(,(car sexp) ,(cadr sexp)
                          (begin ,@(cddr sexp))) sexp))
             (bindings  (letrec->bindings exp))
             (namings   (map (lambda (b) (list (car b) #f)) bindings))
             (names     (letrec->bound-vars exp))
             (sets      (map (lambda (binding) 
                               (cons 'set! binding))
                             bindings))
             (args      (letrec->args exp)))
        `(let ,namings
           (begin ,@(append sets (list (letrec->exp exp)))) )) "" ) )

; begin=>let : begin-exp -> let-exp
(define (begin=>let exp)
  (define (singlet? l)
    (and (list? l)
         (= (length l) 1)))
  
  (define (dummy-bind exps)
    (cond
      ((singlet? exps)  (car exps))
      
      ((pair? exps)     `(let (($_ ,(car exps)))
                          ,(dummy-bind (cdr exps))))))
  (dummy-bind (begin->exps exp)))

; desugar : exp -> exp
(define (desugar exp)
  (cond
    ; Core forms:
    ((const? exp)      exp)
    ((prim? exp)       exp)
    ((ref? exp)        exp)
    ((lambda? exp)     `(lambda ,(lambda->formals exp)
                          ,(desugar (lambda->exp exp))))
    ((set!? exp)       `(set! ,(set!->var exp) ,(set!->exp exp)))
    ((if? exp)         `(if ,(if->condition exp)
                            ,(if->then exp)
                            ,(if->else exp)))
    
    ; Sugar:
    ((let? exp)        (desugar (let=>lambda exp)))
    ((letrec? exp)     (desugar (letrec=>lets+sets exp)))
    ((begin? exp)      (desugar (begin=>let exp)))
    
    ; IR (1):
    ((scell? exp)       `(cell ,(desugar (cell->value exp))))
    ((cell-get? exp)   `(cell-get ,(desugar (cell-get->cell exp))))
    ((set-cell!? exp)  `(set-cell! ,(desugar (set-cell!->cell exp)) 
                                   ,(desugar (set-cell!->value exp))))
    
    ; IR (2): 
    ((closure? exp)    `(closure ,(desugar (closure->lam exp))
                                 ,(desugar (closure->env exp))))
    ((env-make? exp)  `(env-make ,(env-make->id exp)
                          ,@(azip (env-make->fields exp)
                              (map desugar (env-make->values exp)))))
    ((env-get? exp)    `(env-get ,(env-get->id exp)
                                 ,(env-get->field exp)
                                 ,(env-get->env exp)))
    
    ; Applications:
    ((app? exp)        (map desugar exp))    
    (else   (defprim-error 'scheme-error "unknown exp: ~a"
                           (list exp)   ))))
    


(define not-handled "not-handled")

;; Syntactic analysis.

; free-vars : exp -> sorted-set[var]
(define (free-vars exp)
  (cond
    ; Core forms:
    ((const? exp)    '())
    ((prim? exp)     '())    
    ((ref? exp)      (list exp))
    ((lambda? exp)   (difference (free-vars (lambda->exp exp))
                                 (lambda->formals exp)))
    ((if? exp)       (union (free-vars (if->condition exp))
                            (union (free-vars (if->then exp))
                                   (free-vars (if->else exp)))))
    ((set!? exp)     (union (list (set!->var exp)) 
                            (free-vars (set!->exp exp))))
    
    ; Sugar:
    ((let? exp)      (free-vars (let=>lambda exp)))
    ((letrec? exp)   not-handled)
    ((begin? exp)    (sreduce union (map free-vars (begin->exps exp)) '()))

    ; IR (1):
    ((cell-get? exp)  (free-vars (cell-get->cell exp)))
    ((scell? exp)      (free-vars (cell->value exp)))
    ((set-cell!? exp) (union (free-vars (set-cell!->cell exp))
                             (free-vars (set-cell!->value exp))))
    
    ; IR (2):
    ((closure? exp)   (union (free-vars (closure->lam exp))
                             (free-vars (closure->env exp))))
    ((env-make? exp)  (sreduce union (map free-vars (env-make->values exp)) '()))
    ((env-get? exp)   (free-vars (env-get->env exp)))

    ; Application:
    ((app? exp)       (sreduce union (map free-vars exp) '()))
    (else   (defprim-error 'scheme-error
              "unknown expression: ~a" (list exp)  ))))





;; Mutable variable analysis and elimination.

;; Mutables variables analysis and elimination happens
;; on a desugared Intermediate Language (1).

;; Mutable variable analysis turns mutable variables 
;; into heap-allocated cells:

;; For any mutable variable mvar:

;; (lambda (... mvar ...) body) 
;;           =>
;; (lambda (... $v ...) 
;;  (let ((mvar (cell $v)))
;;   body))

;; (set! mvar value) => (set-cell! mvar value)

;; mvar => (cell-get mvar)

; mutable-variables : list[symbol]
(define mutable-variables '())

; mark-mutable : symbol -> void
(define (mark-mutable symbol)
  (set! mutable-variables (cons symbol mutable-variables)))

; is-mutable? : symbol -> boolean
(define (is-mutable? symbol)
  (define (is-in? S)
    (if (not (pair? S))
        #f
        (if (eq? (car S) symbol)
            #t
            (is-in? (cdr S)))))
  (is-in? mutable-variables))

; analyze-mutable-variables : exp -> void
(define (analyze-mutable-variables exp)
  (cond 
    ; Core forms:
    ((const? exp)    (void))
    ((prim? exp)     (void))
    ((ref? exp)      (void))
    ((lambda? exp)   (analyze-mutable-variables (lambda->exp exp)))
    ((set!? exp)     (begin (mark-mutable (set!->var exp))
                            (analyze-mutable-variables (set!->exp exp))))
    ((if? exp)       (begin
                       (analyze-mutable-variables (if->condition exp))
                       (analyze-mutable-variables (if->then exp))
                       (analyze-mutable-variables (if->else exp))))
    
    ; Sugar:
    ((let? exp)      (begin
                       (map analyze-mutable-variables (map cadr (let->bindings exp)))
                       (analyze-mutable-variables (let->exp exp))))
    ((letrec? exp)   (begin
                       (map analyze-mutable-variables (map cadr (letrec->bindings exp)))
                       (analyze-mutable-variables (letrec->exp exp))))
    ((begin? exp)    (begin
                       (map analyze-mutable-variables (begin->exps exp))
                       (void)))
    
    ; Application:
    ((app? exp)      (begin 
                       (map analyze-mutable-variables exp)
                       (void)))
    (else  (defprim-error 'scheme-error 
             "unknown expression type: ~a" (list exp)  ))))


; wrap-mutables : exp -> exp
(define (wrap-mutables exp)
  
  (define (wrap-mutable-formals formals body-exp)
    (if (not (pair? formals))
        body-exp
        (if (is-mutable? (car formals))
            `(let ((,(car formals) (cell ,(car formals))))
               ,(wrap-mutable-formals (cdr formals) body-exp))
            (wrap-mutable-formals (cdr formals) body-exp))))
  
  (cond
    ; Core forms:
    ((const? exp)    exp)
    ((ref? exp)      (if (is-mutable? exp)
                         `(cell-get ,exp)
                         exp))
    ((prim? exp)     exp)
    ((lambda? exp)   `(lambda ,(lambda->formals exp)
                        ,(wrap-mutable-formals (lambda->formals exp)
                                               (wrap-mutables (lambda->exp exp)))))
    ((set!? exp)     `(set-cell! ,(set!->var exp) ,(wrap-mutables (set!->exp exp))))
    ((if? exp)       `(if ,(wrap-mutables (if->condition exp))
                          ,(wrap-mutables (if->then exp))
                          ,(wrap-mutables (if->else exp))))
    
    ; Application:
    ((app? exp)      (map wrap-mutables exp))
    (else   (defprim-error 'scheme-error 
              "unknown expression type: " (list exp)  ))))
                        


;; Name-mangling.

;; We have to "mangle" Scheme identifiers into
;; C-compatible identifiers, because names like
;; foo-bar/baz are not identifiers in C.

; mangle : symbol -> string
(define (mangle symbol)
  (define (m chars)
    (if (null? chars)
        '()
        (if (or (and (char-alphabetic? (car chars)) (not (char=? (car chars) #\_)))
                (char-numeric? (car chars)))
            (cons (car chars) (m (cdr chars)))
            (cons #\_ (append (integer->char-list (char->natural (car chars)))
                              (m (cdr chars)))))))
  (list->string (m (string->list (symbol->string symbol)))))





;; Closure-conversion.

;; Closure conversion operates on a desugared
;; Intermediate Language (2).  Closure conversion
;; eliminates all of the free variables from every
;; lambda term.

;; The transform is:

;;  (lambda (v1 ... vn) body)
;;             =>
;;  (closure (lambda ($env v1 ... vn) 
;;                   {xi => (env-get $id xi $env)}body)
;;           (env-make $id (x1 x1) ... (xn xn)))

;;  where x1,...xn are the free variables in the lambda term.



; type env-id = natural

; num-environments : natural
(define num-environments 0)

; environments : alist*[env-id,symbol]
(define environments '())

; allocate-environment : list[symbol] -> env-id
(define (allocate-environment fields)
  (let ((id num-environments))
    (set! num-environments (+ 1 num-environments))
    (set! environments (cons (cons id fields) environments))
    id))

; get-environment : natural -> list[symbol]
(define (get-environment id)
  (cdr (assv id environments)))


; closure-convert : exp -> exp
(define (closure-convert exp)
  (cond
    ((const? exp)        exp)
    ((prim? exp)         exp)
    ((ref? exp)          exp)
    ((lambda? exp)       (let* (($env (gsym 'env))
                                (body  (closure-convert (lambda->exp exp)))
                                (fv    (difference (free-vars body) (lambda->formals exp)))
                                (id    (allocate-environment fv))
                                (sub  (map (lambda (v)
                                             (list v `(env-get ,id ,v ,$env)))
                                           fv)))
                           `(closure (lambda (,$env ,@(lambda->formals exp))
                                       ,(substitute sub body))
                                     (env-make ,id ,@(azip fv fv)))))
    ((if? exp)           `(if ,(closure-convert (if->condition exp))
                              ,(closure-convert (if->then exp))
                              ,(closure-convert (if->else exp))))
    ((set!? exp)         `(set! ,(set!->var exp)
                                ,(closure-convert (set!->exp exp))))
    
    ; IR (1):
    
    ((scell? exp)         `(cell ,(closure-convert (cell->value exp))))
    ((cell-get? exp)     `(cell-get ,(closure-convert (cell-get->cell exp))))
    ((set-cell!? exp)    `(set-cell! ,(closure-convert (set-cell!->cell exp))
                                     ,(closure-convert (set-cell!->value exp))))
    
    ; Applications:
    ((app? exp)          (map closure-convert exp))
    (else  (defprim-error 'scheme-error 
             "unhandled exp: ~a" (list exp)  ))))
    



;; Compilation routines.

;; plusprimitives
; c-compile-program : exp -> string
(define (c-compile-program exp)
  (let* ((preamble "")
         (append-preamble 
           (lambda (s)
              (set! preamble (str-app preamble "  " s "\n"))))
         (body (c-compile-exp exp append-preamble)))
    (str-app

      
     "int main (int argc, char* argv[]) {\n"
     preamble
     "GC_INIT() ;"
     (apply string-append
	    (map (lambda(x) 
              (fmt  "__~a = MakePrimitive(__prim_~a) ;\n" x x))
               topenv))
     "argtop= argc ;\n"
     "for (int i=0; i<argc;i++) {arg[i]= MakeStr(argv[i]) ;}\n"
     "  __sum         = MakePrimitive(__prim_sum) ;\n" 
     "  __product     = MakePrimitive(__prim_product) ;\n" 
     "  __difference  = MakePrimitive(__prim_difference) ;\n" 
    "  __fsum         = MakePrimitive(__prim_fsum) ;\n" 
     "  __fproduct     = MakePrimitive(__prim_fproduct) ;\n" 
     "  __fdifference  = MakePrimitive(__prim_fdifference) ;\n"
     "  __fdiv         = MakePrimitive(__prim_fdiv) ;\n"
     "  __display     = MakePrimitive(__prim_display) ;\n"
     "  __numLT    = MakePrimitive(__prim_numLT) ;\n"
     "  __numLE    = MakePrimitive(__prim_numLE) ;\n"
     "  __numGT    = MakePrimitive(__prim_numGT) ;\n"
     "  __numGE    = MakePrimitive(__prim_numGE) ;\n"
     
     "  __fnumLT    = MakePrimitive(__prim_fnumLT) ;\n"
     "  __fnumLE    = MakePrimitive(__prim_fnumLE) ;\n"
     "  __fnumGT    = MakePrimitive(__prim_fnumGT) ;\n"
     "  __fnumGE    = MakePrimitive(__prim_fnumGE) ;\n"
     "  __fnumEqual = MakePrimitive(__prim_fnumEqual) ;\n"

     "  __numREM   = MakePrimitive(__prim_numREM) ;\n"
     "  __numQUOT  = MakePrimitive(__prim_numQUOT) ;\n"
     "  __numEqual = MakePrimitive(__prim_numEqual) ;\n"
     "  __pairCons  = MakePrimitive(__prim_pairCons) ;\n"
     "  __pairCar  = MakePrimitive(__prim_pairCar) ;\n"
     "  __pairCdr  = MakePrimitive(__prim_pairCdr) ;\n"
     "  __pairNULL  = MakePrimitive(__prim_pairNULL) ;\n"
     "  __argvOne   = MakePrimitive(__prim_argvOne) ;\n"
     " __stringRef  = MakePrimitive(__prim_stringRef) ;\n"
     " __stringSet = MakePrimitive(__prim_stringSet) ;\n"
     " __stringLength = MakePrimitive(__prim_stringLength) ;\n"
     " __substr = MakePrimitive(__prim_substr) ;\n"
     " __charEq = MakePrimitive(__prim_charEq) ;\n"
     " __charGT = MakePrimitive(__prim_charGT) ;\n"
     " __charLT = MakePrimitive(__prim_charLT) ;\n"
     " __charGE = MakePrimitive(__prim_charGE) ;\n"
     " __charLE = MakePrimitive(__prim_charLE) ;\n"
     " __charNE = MakePrimitive(__prim_charNE) ;\n"
     " __strEq = MakePrimitive(__prim_strEq) ;\n"
     " __strGT = MakePrimitive(__prim_strGT) ;\n"
     " __strLT = MakePrimitive(__prim_strLT) ;\n"
     " __strCat = MakePrimitive(__prim_strCat) ;\n"
     " __NOT    = MakePrimitive(__prim_NOT) ;\n"
     " __strP = MakePrimitive(__prim_strP) ;\n"
     " __charP = MakePrimitive(__prim_charP) ;\n"
     " __pairP = MakePrimitive(__prim_pairP) ;\n"
     " __intP  = MakePrimitive(__prim_intP) ;\n"
     " __floatP = MakePrimitive(__prim_floatP) ;\n"
     " __rdFile = MakePrimitive(__prim_rdFile) ;\n"
     " __wrtFile = MakePrimitive(__prim_wrtFile) ;\n"
     " __rdFromStr   = MakePrimitive(__prim_rdFromStr) ;\n"
     "  " body " ;\n"
     "  return 0;\n"
     " }\n")))


; c-compile-exp : exp (string -> void) -> string
(define (c-compile-exp exp append-preamble)
  (cond
    ; Core forms:
    ((const? exp)       (c-compile-const exp))
    ((prim?  exp)       (c-compile-prim exp))
    ((ref?   exp)       (c-compile-ref exp))
    ((if? exp)          (c-compile-if exp append-preamble))

    ; IR (1):
    ((scell? exp)        (c-compile-cell exp append-preamble))
    ((cell-get? exp)    (c-compile-cell-get exp append-preamble))
    ((set-cell!? exp)   (c-compile-set-cell! exp append-preamble))
    
    ; IR (2):
    ((closure? exp)     (c-compile-closure exp append-preamble))
    ((env-make? exp)    (c-compile-env-make exp append-preamble))
    ((env-get? exp)     (c-compile-env-get exp append-preamble))
    
    ; Application:      
    ((app? exp)         (c-compile-app exp append-preamble))
    (else  (defprim-error 'scheme-error
             "unknown exp in c-compile-exp: ~a" (list exp) ))))

; c-compile-const : const-exp -> string
(define (c-compile-const exp)
  (cond
    ((and (integer? exp) (exact? exp)) (string-append 
                     "MakeInt(" (number->string exp) ")"))
    ((and (number? exp)
          (inexact? exp)) (string-append
                      "MakeFloat(" (number->string exp) ")"))
    ((string? exp) (string-append
                     "MakeStr(\"" exp "\")" ))
    ((char? exp) (string-append
                   "MakeChar(" 
                     (number->string(char->integer exp)) ")"))
    ((boolean? exp) (string-append
                     "MakeBoolean(" (if exp "1" "0") ")"))
    (else (defprim-error 'scheme-error
            "unknown constant: ~a" (list exp)  ))))

;; plusprimitives
; c-compile-prim : prim-exp -> string
(define (c-compile-prim p)
  (cond
    ((eq? '+fx p)       "__sum")
    ((eq? '-fx p)       "__difference")
    ((eq? '*fx p)       "__product")
    ((eq? '+ p)       "__fsum")
    ((eq? '- p)       "__fdifference")
    ((eq? '* p)       "__fproduct")
    ((eq? '/ p)       "__fdiv")

    ((eq? '< p)       "__fnumLT")
    ((eq? '<= p)      "__fnumLE")
    ((eq? '> p)       "__fnumGT")
    ((eq? '>= p)      "__fnumGE")
    ((eq? '= p)       "__fnumEqual")

    ((eq? '<fx p)       "__numLT")
    ((eq? '<=fx p)      "__numLE")
    ((eq? '>fx p)       "__numGT")
    ((eq? '>=fx p)      "__numGE")
    ((eq? '=fx p)       "__numEqual")
    
    ((eq? 'mod p)     "__numREM")
    ((eq? 'quot p)    "__numQUOT")
    ((eq? '= p)       "__numEqual")
    ((eq? 'cons p)    "__pairCons")
    ((eq? 'car p)     "__pairCar")
    ((eq? 'cdr p)     "__pairCdr")
    ((eq? 'null? p)   "__pairNULL")
    ((eq? 'display p) "__display")
    ((eq? 'string-ref p) "__stringRef")
    ((eq? 'string-set! p) "__stringSet")
    ((eq? 'string-length p) "__stringLength")
    ((eq?  'substr p) "__substr")
    ((eq? 'arg p) "__argvOne")
    ((eq? 'char=? p) "__charEq")
    ((eq? 'char>? p) "__charGT")
    ((eq? 'char<? p) "__charLT")
    ((eq? 'char>=? p) "__charGE")
    ((eq? 'char<=? p) "__charLE")
    ((eq? 'char~=? p) "__charNE")
    ((eq? 'string=? p) "__strEq")
    ((eq? 'string>? p) "__strGT")
    ((eq? 'string<? p) "__strLT")
    ((eq? 'strcat p)   "__strCat")
    ((eq? 'not p) "__NOT")
    ((eq? 'string? p) "__strP")
    ((eq? 'char? p)   "__charP")
    ((eq? 'pair? p)   "__pairP")
    ((eq? 'integer? p) "__intP")
    ((eq? 'float? p) "__floatP")
    ((eq? 'read-file p) "__rdFile")
    ((eq? 'write-file p) "__wrtFile")
    ((eq? 'read-from-string p) "__rdFromStr")
    [(smember p topenv)
     (fmt  "__~a" p )]
    (else  (defprim-error 'scheme-error
             "unhandled primitive: ~a" (list p)  ))))

; c-compile-ref : ref-exp -> string
(define (c-compile-ref exp)
  (mangle exp))
  
; c-compile-args : list[exp] (string -> void) -> string
(define (c-compile-args args append-preamble)
  (if (not (pair? args))
      ""
      (string-append
       (c-compile-exp (car args) append-preamble)
       (if (pair? (cdr args))
           (string-append ", " (c-compile-args (cdr args) append-preamble))
           ""))))

; c-compile-app : app-exp (string -> void) -> string
(define (c-compile-app exp append-preamble)
  (let (($tmp (mangle (gsym 'tmp))))
    
    (append-preamble (string-append
                      "Value " $tmp " ; "))
    
    (let* ((args     (app->args exp))
           (fun      (app->fun exp)))
      (string-append
       "("  $tmp " = " (c-compile-exp fun append-preamble) 
       ","
       $tmp ".clo.lam("
       "MakeEnv(" $tmp ".clo.env)"
       (if (null? args) "" ",")
       (c-compile-args args append-preamble) "))"))))
  
; c-compile-if : if-exp -> string
(define (c-compile-if exp append-preamble)
  (string-append
   "(" (c-compile-exp (if->condition exp) append-preamble) ").b.value ? "
   "(" (c-compile-exp (if->then exp) append-preamble)      ") : "
   "(" (c-compile-exp (if->else exp) append-preamble)      ")"))

; c-compile-set-cell! : set-cell!-exp (string -> void) -> string 
(define (c-compile-set-cell! exp append-preamble)
  (string-append
   "(*"
   "(" (c-compile-exp (set-cell!->cell exp) append-preamble) ".cell.addr)" " = "
   (c-compile-exp (set-cell!->value exp) append-preamble)
   ")"))

; c-compile-cell-get : cell-get-exp (string -> void) -> string 
(define (c-compile-cell-get exp append-preamble)
  (string-append
   "(*("
   (c-compile-exp (cell-get->cell exp) append-preamble)
   ".cell.addr"
   "))"))

; c-compile-cell : cell-exp (string -> void) -> string
(define (c-compile-cell exp append-preamble)
  (string-append
   "NewCell(" (c-compile-exp (cell->value exp) append-preamble) ")"))

; c-compile-env-make : env-make-exp (string -> void) -> string
(define (c-compile-env-make exp append-preamble)
  (string-append
   "MakeEnv(__alloc_env" (number->string (env-make->id exp))
   "(" 
   (c-compile-args (env-make->values exp) append-preamble)
   "))"))

; c-compile-env-get : env-get (string -> void) -> string
(define (c-compile-env-get exp append-preamble)
  (string-append
   "((struct __env_"
   (number->string (env-get->id exp)) "*)" 
   (c-compile-exp (env-get->env exp) append-preamble) ".env.env)->" 
   (mangle (env-get->field exp))))




;; Lambda compilation.

;; Lambdas get compiled into procedures that, 
;; once given a C name, produce a C function
;; definition with that name.

;; These procedures are stored up an eventually 
;; emitted.

; type lambda-id = natural

; num-lambdas : natural
(define num-lambdas 0)

; lambdas : alist[lambda-id,string -> string]
(define lambdas '())

; allocate-lambda : (string -> string) -> lambda-id
(define (allocate-lambda lam)
  (let ((id num-lambdas))
    (set! num-lambdas (+ 1 num-lambdas))
    (set! lambdas (cons (list id lam) lambdas))
    id))

; get-lambda : lambda-id -> (symbol -> string)
(define (get-lambda id)
  (cdr (assv id lambdas)))

; c-compile-closure : closure-exp (string -> void) -> string
(define (c-compile-closure exp append-preamble)
  (let* ((lam (closure->lam exp))
         (env (closure->env exp))
         (lid (allocate-lambda (c-compile-lambda lam))))
    (string-append
     "MakeClosure("
     "__lambda_" (number->string lid)
     ","
     (c-compile-exp env append-preamble)
     ")")))

; c-compile-formals : list[symbol] -> string
(define (c-compile-formals formals)
  (if (not (pair? formals))
      ""
      (string-append
       "Value "
       (mangle (car formals))
       (if (pair? (cdr formals))
           (string-append ", " (c-compile-formals (cdr formals)))
           ""))))

; c-compile-lambda : lamda-exp (string -> void) -> (string -> string)
(define (c-compile-lambda exp)
  (let* ((preamble "")
         (append-preamble (lambda (s)
                            (set! preamble (string-append preamble "  " s "\n")))))
    (let ((formals (c-compile-formals (lambda->formals exp)))
          (body    (c-compile-exp     (lambda->exp exp) append-preamble)))
      (lambda (name)
        (string-append "Value " name "(" formals ") {\n"
                       preamble
                       "  return " body " ;\n"
                       "}\n")))))

; c-compile-env-struct : list[symbol] -> string
(define (c-compile-env-struct env)
  (let* ((id     (car env))
         (fields (cdr env))
         (sid    (number->string id))
         (tyname (string-append "struct __env_" sid)))
    (string-append 
     "struct __env_" (number->string id) " {\n" 
     (apply string-append (map (lambda (f)
                                 (string-append
                                  " Value "
                                  (mangle f) 
                                  " ; \n"))
                               fields))
     "} ;\n\n"
     tyname "*" " __alloc_env" sid 
     "(" (c-compile-formals fields) ")" "{\n"
     "  " tyname "*" " txpto = GC_MALLOC(sizeof(" tyname "))" ";\n"
     (apply string-append 
            (map (lambda (f)
                   (string-append "  txpto->" (mangle f)
                                  " = " (mangle f) ";\n"))
                 fields))
     "  return txpto;\n"
     "}\n\n"
     )))
    



;; Code emission.
(define (emit line)
  (display line)
  (newline))
  
; c-compile-and-emit : (string -> A) exp -> void
(define (c-compile-and-emit emit input-program)

  (define compiled-program "")
  
  (set! input-program (desugar input-program))

  (analyze-mutable-variables input-program)

  (set! input-program (desugar (wrap-mutables input-program)))

  (set! input-program (closure-convert input-program))
  


  (emit "#include <stdlib.h>")
  (emit "#include <stdio.h>")
  (emit "#include \"scheme.h\"")
  
  (emit "")

;; plusprimitives
;; Create storage for primitives:

(let loop [(df def)]
  (when (pair? df)
    (emit (value-declaration (car df)))
    (loop (cdr df)) )) ;; OjO

  (emit "
Value __idiv ;
Value __sum ;
Value __difference ;
Value __product ;
Value __fsum ;
Value __fdifference ;
Value __fproduct ;
Value __fdiv ;
Value __display ;

Value __numLT ;
Value __numLE ;
Value __numGT ;
Value __numGE ;

Value __fnumLT ;
Value __fnumLE ;
Value __fnumGT ;
Value __fnumGE ;
Value __fnumEqual ;

Value __numREM;
Value __numQUOT;
Value __pairCons;
Value __pairCar;
Value __pairCdr;
Value __pairNULL;
Value __numEqual ;
Value __argvOne ;
Value __stringRef ;
Value __stringSet ;
Value __stringLength ;
Value __substr ;
Value __charEq ;
Value __charGT ;
Value __charLT ;
Value __charGE ;
Value __charLE ;
Value __charNE ;
Value __strEq ;
Value __strGT ;
Value __strLT ;
Value __strCat ;
Value __NOT ;
Value __strP ;
Value __charP ;
Value __pairP ;
Value __intP ;
Value __floatP ;
Value __rdFile ;
Value __wrtFile ;
Value __rdFromStr ;
")
  
  (for-each 
   (lambda (env)
     (emit (c-compile-env-struct env)))
   environments)

  (set! compiled-program  (c-compile-program input-program))

(emit "int argtop ;\n")
(emit "Value arg[20] ;\n")

(emit "char* substr(char *src, int m, int len)
{ char *dest= (char *)GC_MALLOC(sizeof(char) * (len+1));
  for (int i=m; i< m+len &&(*(src + i) != 0); i++) {
    *dest= *(src+i); dest++;}
  *dest= 0;
  return dest - len ;
}")



  (emit
   "Value __prim_pairCons(Value e, Value a, Value b) {
  return NewCons(a, b) ;
}")
  (emit
   "Value __prim_pairCar(Value e, Value a) {
  return *a.cons.car ;
}")

(emit
   "double __fl(Value a) {
  return a.f.value ;
}")

(emit
   "int __int(Value a) {
  return a.z.value ;
}")


(emit
   "Value __fexpr(Value e, double a) {
  return MakeFloat(a) ;
}")

(emit
   "Value __iexpr(Value e, int a) {
  return MakeInt(a) ;
}")

  (emit
   "Value __prim_pairCdr(Value e, Value d) {
  return *d.cons.cdr ;
}")

   (emit
 "Value __prim_pairNULL(Value e, Value d) {
  return MakeBoolean(d.n.t == NIL) ;
}")

  (emit
 "int __isNil(Value e, Value d) {
  return (d.n.t == NIL) ;
}")


(let loop [(df def)]
  (when (pair? df)
    (emit (cside (car df)))
    (emit (scheme-side (car df)))
    (loop (cdr df)) )) ;; OjO

  
  ;; Emit primitive procedures:
  (emit 
   "Value __prim_sum(Value e, Value a, Value b) {
    if ((a.z.t != INT) || (b.z.t != INT))
      {printf(\"Type error in addition.\\n\"); exit(503);}
  return MakeInt(a.z.value + b.z.value) ;
}")
  
  (emit 
   "Value __prim_product(Value e, Value a, Value b) {
    if ((a.z.t != INT) || (b.z.t != INT))
      {printf(\"Type error in multiplication.\\n\"); exit(503);}
  return MakeInt(a.z.value * b.z.value) ;
}")
  
  (emit 
   "Value __prim_difference(Value e, Value a, Value b) {
     if ((a.z.t != INT) || (b.z.t != INT))
      {printf(\"Type error in subtraction.\\n\"); exit(503);}
  return MakeInt(a.z.value - b.z.value) ;
}")
   (emit 
   "Value __prim_fsum(Value e, Value a, Value b) {
  return MakeFloat(a.f.value + b.f.value) ;
}")
  
  (emit 
   "Value __prim_fproduct(Value e, Value a, Value b) {
  return MakeFloat(a.f.value * b.f.value) ;
}")
  
  (emit 
   "Value __prim_fdifference(Value e, Value a, Value b) {
  return MakeFloat(a.f.value - b.f.value) ;
}")

(emit 
   "Value __prim_fdiv(Value e, Value a, Value b) {
  return MakeFloat(a.f.value / b.f.value) ;
}")


  (emit
   "Value __prim_display(Value e, Value v) {
  //printf(\"%i\\n\",v.z.value) ;
  prsexpr(v);
  printf(\"\\n\");
  return v ;
}")

;; plusprimitives

(emit
  "Value __prim_argvOne(Value e, Value i) {
    if (i.z.value < argtop) return arg[i.z.value];
    else return arg[0];
  };")

 (emit
   "Value __prim_NOT(Value e, Value g) {
  if ((g.b.t == BOOLEAN) && (g.b.value == 0)) {return MakeBoolean(0);}
  else return MakeBoolean(1);
}")

(emit
  "Value __prim_strP(Value e, Value g) {
     return MakeBoolean(g.s.t == STR);
  }")

(emit
  "Value __prim_charP(Value e, Value g) {
     return MakeBoolean(g.c.t == CHAR);
  }")

(emit
  "Value __prim_pairP(Value e, Value g) {
     return MakeBoolean(g.cons.t == CONS);
  }")

(emit
  "Value __prim_intP(Value e, Value g) {
     return MakeBoolean(g.z.t == INT);
  }")

(emit
  "Value __prim_floatP(Value e, Value g) {
     return MakeBoolean(g.f.t == FLOAT );
  }")


 (emit
   "Value __prim_numLT(Value e, Value a, Value b) {
  return MakeBoolean(a.z.value < b.z.value) ;
}")

(emit
   "Value __prim_numGT(Value e, Value a, Value b) {
  return MakeBoolean(a.z.value > b.z.value) ;
}")

(emit
   "Value __prim_numGE(Value e, Value a, Value b) {
  return MakeBoolean(a.z.value >= b.z.value) ;
}")

  (emit
   "Value __prim_numLE(Value e, Value a, Value b) {
  return MakeBoolean(a.z.value <= b.z.value) ;
}")

 (emit
   "Value __prim_fnumLT(Value e, Value a, Value b) {
  return MakeBoolean(a.f.value < b.f.value) ;
}")

(emit
   "Value __prim_fnumGT(Value e, Value a, Value b) {
  return MakeBoolean(a.f.value > b.f.value) ;
}")

(emit
   "Value __prim_fnumGE(Value e, Value a, Value b) {
  return MakeBoolean(a.f.value >= b.f.value) ;
}")

  (emit
   "Value __prim_fnumLE(Value e, Value a, Value b) {
  return MakeBoolean(a.f.value <= b.f.value) ;
}")

  (emit
   "Value __prim_fnumEqual(Value e, Value a, Value b) {
  return MakeBoolean(a.f.value == b.f.value) ;
}")

  (emit 
   "Value __prim_charEq(Value e, Value a, Value b) {
    if ((a.c.t != CHAR) || (b.c.t != CHAR))
      {printf(\"Type error in char=?\\n\"); exit(503);}
  return MakeBoolean(a.c.value == b.c.value) ;
}")
  
     (emit 
   "Value __prim_charGT(Value e, Value a, Value b) {
    if ((a.c.t != CHAR) || (b.c.t != CHAR))
      {printf(\"Type error in char>?\\n\"); exit(503);}
  return MakeBoolean(a.c.value > b.c.value) ;
}")
 (emit 
   "Value __prim_charLT(Value e, Value a, Value b) {
    if ((a.c.t != CHAR) || (b.c.t != CHAR))
      {printf(\"Type error in char<?\\n\"); exit(503);}
  return MakeBoolean(a.c.value < b.c.value) ;
}")
 (emit 
   "Value __prim_charGE(Value e, Value a, Value b) {
    if ((a.c.t != CHAR) || (b.c.t != CHAR))
      {printf(\"Type error in char>=?\\n\"); exit(503);}
  return MakeBoolean(a.c.value >= b.c.value) ;
}")
 (emit 
   "Value __prim_charLE(Value e, Value a, Value b) {
    if ((a.c.t != CHAR) || (b.c.t != CHAR))
      {printf(\"Type error in char<=?\\n\"); exit(503);}
  return MakeBoolean(a.c.value <= b.c.value) ;
}")
  (emit 
   "Value __prim_charNE(Value e, Value a, Value b) {
    if ((a.c.t != CHAR) || (b.c.t != CHAR))
      {printf(\"Type error in char~=?\\n\"); exit(503);}
  return MakeBoolean(a.c.value != b.c.value) ;
}")

 (emit 
   "Value __prim_strEq(Value e, Value a, Value b) {
    if ((a.s.t != STR) || (b.s.t != STR))
      {printf(\"Type error in string=?\\n\"); exit(503);}
  return MakeBoolean(strcmp(a.s.value, b.s.value) == 0) ;
}")
 (emit 
   "Value __prim_strLT(Value e, Value a, Value b) {
    if ((a.s.t != STR) || (b.s.t != STR))
      {printf(\"Type error in string<?\\n\"); exit(503);}
  return MakeBoolean(strcmp(a.s.value, b.s.value) < 0) ;
}")
  (emit 
   "Value __prim_strGT(Value e, Value a, Value b) {
    if ((a.s.t != STR) || (b.s.t != STR))
      {printf(\"Type error in string>?\\n\"); exit(503);}
  return MakeBoolean(strcmp(a.s.value, b.s.value) > 0) ;
}")

  (emit 
   "Value __prim_strCat(Value e, Value a, Value b) {
    if ((a.s.t != STR) || (b.s.t != STR))
      {printf(\"Type error in strcat\\n\"); exit(503);}
  char *result;
  result = GC_MALLOC(strlen(a.s.value)+strlen(b.s.value)+2);
  strcpy(result, a.s.value);
  strcpy(result+strlen(a.s.value), b.s.value);
  return MakeStr(result) ;

}")


(emit
 "Value __prim_numREM(Value e, Value a, Value b) {
     if ((a.z.t != INT) || (b.z.t != INT))
      {printf(\"Type error in division.\\n\"); exit(503);}
      if (b.z.value == 0) {
        {printf(\"Division by 0.\\n\"); exit(503);}
      }
  return MakeInt(a.z.value % b.z.value) ;
}")
   (emit
 "Value __prim_numQUOT(Value e, Value a, Value b) {
      if ((a.z.t != INT) || (b.z.t != INT))
        {printf(\"Type error in division.\\n\"); exit(503);}
      if (b.z.value == 0) {
        {printf(\"Division by 0.\\n\"); exit(503);}
      }
  return MakeInt(((int) a.z.value) / 
                       ((int) b.z.value)) ;
}")

  (emit
   "Value __prim_numEqual(Value e, Value a, Value b) {
  return MakeBoolean(a.z.value == b.z.value) ;
}")

(emit
  "Value __prim_stringRef(Value e, Value a, Value i) {
  if ((a.s.t != STR) || (i.z.t != INT)) {
    printf(\"Type error in string-ref\\n\");
    exit(518);
  }
  if ( (i.z.value >= strlen(a.s.value)) ||
       (i.z.value < 0)) {
    printf(\"String index out of range: %i.\\n\", i.z.value);
    exit(518);}
  else return MakeChar(a.s.value[i.z.value]);
}")

(emit
  "Value __prim_stringSet(Value e, Value a, Value i, Value b) {
  if ( (a.s.t != STR) || (i.z.t != INT) ||
       (b.c.t != CHAR) ) {
    printf(\"Type error in string-set!\\n\");
    exit(518);
  }
  if ( (i.z.value >= strlen(a.s.value)) ||
       (i.z.value < 0)) {
    printf(\"Index out of range in string-set!: %i.\\n\", i.z.value);
    exit(518);}

     a.s.value[i.z.value]= b.c.value;
     return a;}")

(emit
  "Value __prim_stringLength(Value e, Value a) {
    if ( (a.s.t != STR)  ) {
      printf(\"Type error in string-length\\n\");
      exit(518);}
    
    return MakeInt(strlen(a.s.value));}")

(emit
   "Value __prim_substr(Value e, Value a, Value i, Value j) {
  if ( (a.s.t != STR) || (i.z.t != INT) ||
       (j.z.t != INT) ) {
    printf(\"Type error in substr\\n\");
    exit(518);
  }
  if ( (i.z.value >= strlen(a.s.value)) ||
       (i.z.value < 0) || 
       ((i.z.value + j.z.value) >= strlen(a.s.value))) {
    printf(\"Index out of range in substr: %i.\\n\", 
                   i.z.value + j.z.value);
    exit(518);}

      return MakeStr(substr(a.s.value, i.z.value, j.z.value));
}")

(emit
  "Value __prim_rdFile(Value e, Value a) {
  if (a.s.t != STR) {
    printf(\"Type error in read-file\\n\");
	  exit(518);
	  }
  Value v;
  char *buffer=0;
  long length;
  FILE *f= fopen(a.s.value, \"rb\");
  if (f)
  { fseek(f, 0, SEEK_END);
    length= ftell(f);
    fseek(f, 0, SEEK_SET);
    buffer = GC_MALLOC(length);
    if (buffer) { if (!fread(buffer, 1, length, f))
                   printf(\"Read failed\");
		}
    fclose(f);
    }
  //*(buffer+length)= 0;
  v.s.t= STR;
  v.s.value= buffer;
  return v;
}")

(emit
  "Value __prim_wrtFile(Value e, Value fpth, Value c) {
    if ( (fpth.s.t != STR) || (c.s.t != STR )) {
      printf(\"Type error in write-file\\n\");
      exit(517);
     }
    FILE *fpw;
    fpw= fopen(fpth.s.value, \"w\");
    if (fpw == NULL) {
      puts(\"Issue in opening output file\");
    }
    fputs(c.s.value, fpw);
    fclose(fpw);
    return MakeBoolean(0);
}")

(emit
  "Value __prim_rdFromStr(Value e, Value a) {
  if (a.s.t != STR) {
    printf(\"Type error in read-from-string\\n\");
	  exit(518);
  }//end type check
  int checkParens;
  checkParens= 0;
  ss= a.s.value;
  return parse_term(&checkParens);
}")


  ;; Emit lambdas:
  ; Print the prototypes:
  (for-each
   (lambda (l)
     (emit (string-append "Value __lambda_" (number->string (car l)) "() ;")))
   lambdas)
  
  (emit "")
  
  ; Print the definitions:
  (for-each
   (lambda (l)
     (emit ((cadr l) (string-append "__lambda_" (number->string (car l))))))
   lambdas)
  
  (emit compiled-program))


(define (mkcons s)
  (cond [(null? s) #f]
        [(not (pair? s)) s]
        [else `(cons ,(mkcons (car s))
                     ,(mkcons (cdr s)))]))


        
(define (normop s)
  (define (rightassoc z)
    (list (car z) 
         (normop (cadr z)) 
                (normop (cons (car z) (cddr z))) ))
  (define (leftassoc op z)
    (cond [(= (length z) 1) z]
          [(= (length z) 2)
           (list op (normop (car z)) 
                 (normop (cadr z)))]
          [else (leftassoc op 
                 (cons
                   (list op (normop (car z))
                         (normop (cadr z)))
                   (cddr z)))]))
  (cond [(not (pair? s)) s]
        [(and (smember (car s) '(*fx +fx *  +))
              (> (length (cdr s)) 2))
         (rightassoc s)]
       [(and (smember (car s) '(quot / -fx -))
              (> (length (cdr s)) 2))
         (leftassoc (car s) (cdr s))]
       [(and (pair? s) (equal? (car s) 'quote))
	(mkcons (cadr s))]
       [else (cons (normop (car s))
                    (normop (cdr s)))]))

 (define-syntax //
  (syntax-rules () 
     [(// x y) (if x x y)]
     [(// x y z ...) (if x x (// y z ...))]))

(define-syntax &&
  (syntax-rules ()
  ;;  [(&& x) x]
    [(&& x y) (if x y #f)]
  ;;  [(&& x y z ...) (if x y (&& z ...))]
    ))

 
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
        [(equal? (car s) '//) (expand s )]
        [(equal? (car s) '&&) (expand s)]
        [(equal? (car s) 'or) (expand (cons '// (cdr s)))]
        [(equal? (car s) 'and) (expand (cons '&& (cdr s)))]
        [else (cons (cexpand (car s))
                    (cexpand (cdr s)))]))

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


(define (compit inp oup)
  (let* 
    [(code (insDef (rdcode inp)))
     (prelude (reverse (cdr code)))
     (the-program (car code))]
     (when (pair? prelude)
        (set! def prelude)
        (set! topenv
           (map (lambda(x)  (car (cadr x))) def)))
     (with-output-to-file oup
       (lambda()
         (c-compile-and-emit emit
           (cexpand (normop the-program)) )))
     (set! lambdas '())
     (set! num-lambdas 0)
     (set! mutable-variables '())
     (set! num-environments 0)
     (set! environments '())
     (set! def '())
     (set! topenv '() )))

;; End OjO ===============

;; Compile and emit:

;; (define the-program (read))

;;(c-compile-and-emit emit the-program)

; Suitable definitions for the cell functions:
(define (cell value) (lambda (get? new-value) 
                       (if get? value (set! value new-value))))
(define (set-cell! c v) (c #f v))
(define (cell-get c) (c #t #t))

(define (maketests)
  (compit "examples/test01.scm" "test01.c")
  (compit "examples/test02.scm" "test02.c")
  (compit "examples/test03.scm" "test03.c")
  (compit "examples/test04.scm" "test04.c")
  (compit "examples/test05.scm" "test05.c")
  (compit "examples/test06.scm" "test06.c")
  (compit "examples/test07.scm" "test07.c")
  (compit "examples/test08.scm" "test08.c")
  (compit "examples/test09.scm" "test09.c")
  (compit "examples/test10.scm" "test10.c")
  (compit "examples/test11.scm" "test11.c")
  (compit "examples/test12.scm" "test12.c")
  (compit "examples/acc.scm"  "acc.c")
  (compit "examples/add.scm"  "add.c")
  (compit "examples/consin.scm"  "consin.c")
  (compit "examples/cons.scm"  "cons.c")
  (compit "examples/fib.scm"  "fib.c")
  (compit "examples/funDNA.scm"   "funDNA.c")
  (compit "examples/implicit-begin.scm" "implicit-begin.c")
  (compit "examples/loop.scm"  "loop.c")
  (compit "examples/ofib.scm"  "ofib.c")
  (compit "examples/oloop.scm"  "oloop.c")
  (compit "examples/str.scm"  "str.c")
  (compit "examples/temperature.scm"  "temperature.c")
  (compit "examples/testand.scm" "testand.c")
  (compit "examples/testchr.scm" "testchr.c")
  (compit "examples/testdef.scm" "testdef.c")
  (compit "examples/testMth.scm" "testMth.c")
  (compit "examples/testrd.scm" "testrd.c")
  (compit "examples/teststrcmp.scm" "teststrcmp.c")
  (compit "examples/testStr.scm" "testStr.c"))

