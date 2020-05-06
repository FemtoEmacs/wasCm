(define (end? s n) (<= (string-length s) n))

(define (pct? s n) (string-char-index ".,?" (string-ref s n)))

(define (blk? s n) (string-char-index " \n" (string-ref s n)))

(define (letter? s n)
  (and (not (pct? s n)) (not (blk? s n)) ))

(define (skp n s)
   (if (or (end? s n) (not (blk? s n))) n
      (skp (+ n 1) s)))

(define (q1 n s)
   (cond ( (end? s n) n)
         ( (pct? s n) (+ n 1) )
         (else (q3 n s)) ))

(define (q3 n s )
   (cond ( (end? s n) n)
         ( (letter?  s n) (q3 (+ n 1) s))
         (else  n)))

(define (tkz s #!optional (n 0) (i (skp n s)) (j (q1 i s)))
  (cond ( (end? s i) '())
          ( (end? s j) (list (substring s i j)))
          (else (cons (substring s i j) (tkz s j)) ) ))
