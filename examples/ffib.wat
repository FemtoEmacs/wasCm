(module (func
         $fib
         (param $x f64)
         (result f64)
         (if (result f64)
           (f64.lt (get_local $x) (f64.const 2.0))
           (then (f64.const 1.0))
           (else (f64.add
                   (call $fib
                         (f64.sub (get_local $x) (f64.const 1.0)))
                   (call $fib
                         (f64.sub (get_local $x) (f64.const 2.0)))))))
  (export "fib" (func $fib)))



