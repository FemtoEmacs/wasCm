(module
  (memory (export "mem") 1)
  (data (i32.const 1004) "String demo.")
  (data (i32.const 1204) "Hello, you Guys!")

  (func $setmem (param $n i32) (param $v i32)  (result)
     (i32.store  (local.get $n) (local.get $v)))
  
  (export "set" (func $setmem))

  (func $getsz (param $n i32) (result i32)
    (i32.load (local.get $n)))

  (export "getsize" (func $getsz))

  (func $initstr (result)
     (i32.store (i32.const 1000) (i32.const 12))
     (i32.store (i32.const 1200) (i32.const 15)))

  (export "initstr"  (func $initstr))
  (global (export "pos") i32 (i32.const 1000)))
  