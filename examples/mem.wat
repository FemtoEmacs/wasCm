(module (memory $mem 1 4)
  (export "mem" (memory $mem))
  (func $setmem.n
        (param $n i32)
        (param $v.i i32)
        (result i32)
        (i32.store
          (i32.mul (get_local $n) (i32.const 4))
          (get_local $v.i))
        (i32.const 42))
  (export "setmem" (func $setmem.n))
  (func $plusfive.n
        (param $n i32)
        (result i32)
        (i32.add
          (i32.const 5)
          (i32.load (i32.mul (get_local $n) (i32.const 4)))))
  (export "plusfive" (func $plusfive.n)))



