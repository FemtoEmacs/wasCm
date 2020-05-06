;; File readfromstring.scm

(define (rdstr str)
  (let* [ (port (open-input-string str))
          (res (read port))]
      (close-input-port port) res) )

#|
1:=> (load "readfromstring.scm")
readfromstring.scm
1:=> (load "zellerCond.scm")
zellerCond.scm
1:=> (zeller 2016 8 31)
Wednesday
1:=> (apply zeller (rdstr "(2016 8 31)"))
Wednesday
|#
