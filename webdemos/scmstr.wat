(module (memory $mem 1 2)
  (export "mem" (memory $mem))
  (data (i32.const 1004) "Hello, World!")
  (data (i32.const 1104) "Hi, Suzy")
  (func $initstr
        (result)
        (i32.store (i32.const 1000) (i32.const 13))
        (i32.store (i32.const 1100) (i32.const 8)))
  (export "initstr" (func $initstr))
  (func $pos
        (param $n i32)
        (result i32)
        (i32.add
          (i32.const 1000)
          (i32.mul (local.get $n) (i32.const 100))))
  (export "pos" (func $pos))
  (func $getsz
        (param $n i32)
        (result i32)
        (i32.load (call $pos (local.get $n))))
  (export "getsize" (func $getsz)))



