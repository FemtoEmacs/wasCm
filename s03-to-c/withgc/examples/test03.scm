(letrec 
  [ (f03 (lambda(x y) (if (<fx x 5) 42 (*fx x x y)) ))
    (f04 (lambda(x y) (if (<=fx x 5) 42 (*fx x y)) ))
    (f05 (lambda(x y) (if (>=fx x 5) 42 (*fx x y)) ))
    (f06 (lambda(x y) (if (>fx x 5) 42 (*fx x y)) ))
    (f07 (lambda(x y) (if (<=fx x 5) 42 (mod x y)) ))
    (f08 (lambda(x y) (if (>fx x 15) 42 (quot x y 2)) ))]
  (display (f03 5 9)) 
  (display (f04 5 9))
  (display (f05 5 9))
  (display (f06 5 9))
  (display (f07 29 6))
  (display (f08 15 3)))




