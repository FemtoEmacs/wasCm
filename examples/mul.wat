(module (func
         $multiply
         (param $x f64)
         (param $y f64)
         (result f64)
         (f64.mul
           (get_local $x)
           (f64.mul (get_local $y) (f64.const 4.0))))
  (export "multiply" (func $multiply)))



