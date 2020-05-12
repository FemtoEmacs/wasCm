(module (func
         $fib.n
         (param $i i32)
         (result i32)
         (if (result i32)
           (i32.lt_s (get_local $i) (i32.const 2))
           (then (i32.const 1))
           (else (i32.add
                   (call $fib.n
                         (i32.sub (get_local $i) (i32.const 1)))
                   (call $fib.n
                         (i32.sub (get_local $i) (i32.const 2)))))))
  (export "fib" (func $fib.n)))



