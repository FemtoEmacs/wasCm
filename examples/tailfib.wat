(module (func
         $fib.n
         (param $i i32)
         (param $f1.n i32)
         (param $f2.n i32)
         (result i32)
         (local $res i32)
         (block $exit
                (loop $tre
                      (br_if $exit
                             (i32.lt_s (get_local $i) (i32.const 2))
                             (local.set $res (get_local $f1.n)))
                      (block (get_local $f1.n)
                             (i32.add (get_local $f1.n) (get_local $f2.n))
                             (i32.sub (get_local $i) (i32.const 1))
                             (local.set $i)
                             (local.set $f1.n)
                             (local.set $f2.n)
                             (br $tre))))
         (get_local $res))
  (export "fib" (func $fib.n))
  (func $ffib
        (param $i i32)
        (param $f1 f64)
        (param $f2 f64)
        (result f64)
        (local $res f64)
        (block $exit
               (loop $tre
                     (br_if $exit
                            (i32.lt_s (get_local $i) (i32.const 2))
                            (local.set $res (get_local $f1)))
                     (block (get_local $f1)
                            (f64.add (get_local $f1) (get_local $f2))
                            (i32.sub (get_local $i) (i32.const 1))
                            (local.set $i)
                            (local.set $f1)
                            (local.set $f2)
                            (br $tre))))
        (get_local $res))
  (export "ffib" (func $ffib)))



