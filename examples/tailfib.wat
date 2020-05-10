(module (func
         $fib
         (param $n i32)
         (param $f1 i32)
         (param $f2 i32)
         (result i32)
         (local $res i32)
         (block $exit
                (loop $tre
                      (br_if $exit
                             (i32.lt_s (get_local $n) (i32.const 2))
                             (local.set $res (get_local $f1)))
                      (block (get_local $f1)
                             (i32.add (get_local $f1) (get_local $f2))
                             (i32.sub (get_local $n) (i32.const 1))
                             (local.set $n)
                             (local.set $f1)
                             (local.set $f2)
                             (br $tre))))
         (get_local $res))
  (export "fib" (func $fib))
  (func $ffib.x
        (param $n i32)
        (param $f1.x f64)
        (param $f2.x f64)
        (result f64)
        (local $res f64)
        (block $exit
               (loop $tre
                     (br_if $exit
                            (i32.lt_s (get_local $n) (i32.const 2))
                            (local.set $res (get_local $f1.x)))
                     (block (get_local $f1.x)
                            (f64.add (get_local $f1.x) (get_local $f2.x))
                            (i32.sub (get_local $n) (i32.const 1))
                            (local.set $n)
                            (local.set $f1.x)
                            (local.set $f2.x)
                            (br $tre))))
        (get_local $res))
  (export "ffib" (func $ffib.x)))



