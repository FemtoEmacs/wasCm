(define get-line read-line)

(define (tag i <h> x </h> )
   (let [ (Len (string-length x))]
      (string-append <h>
          (substring x i (- Len 1)) </h> "\n")))

(define (subtitle? x)
  (and (> (string-length x) 4)
       (char=? (string-ref x 0) #\#)
       (char=? (string-ref x 1) #\#)))

(define (title? x)
   (and (> (string-length x) 3)
        (char=? (string-ref x 0) #\#)))

(define (convert in out)
  (let loop ( (x (get-line in)) )
     (cond [ (eof-object? x) #t]
        [ (subtitle? x)
          (display (tag 2 "<h2>" x "</h2>") out)
          (loop (get-line in))]
        [ (title? x)
          (display (tag 1 "<h1>" x "</h1>") out)
	  (loop (get-line in))]
        [ (> (string-length x) 1)
          (display x out)
          (display "<br/>\n" out)
          (loop (get-line in))]
        [ else (display "<p/>\n" out)
	    (loop (get-line in))] )))

(define (copyFile inFile outFile)
   (call-with-output-file outFile
      (lambda(out) (call-with-input-file inFile
         (lambda(in) (convert in out))) )))

#|
1:=> (load "prtFile.scm")
prtFile.scm
1:=> (load "tohtml.scm")
tohtml.scm
1:=> (copyFile "helen.md" "helen.html")
#t
|#
