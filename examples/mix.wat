(module (func
         $mixed
         (param $n.x f64)
         (param $n.y f64)
         (param $i i32)
         (result f64)
         (f64.add
           (get_local $n.x)
           (f64.add
             (get_local $n.y)
             (f64.add
               (f64.convert_s/i32
                 (i32.add
                   (get_local $i)
                   (i32.add (get_local $i) (get_local $i))))
               (f64.const 5.0)))))
  (export "mixed" (func $mixed)))



