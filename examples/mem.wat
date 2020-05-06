(module (memory $mem 1 4) (export "mem" (memory $mem)) (func $setmem (param $n i32) (param $v i32) (result i32) (i32.store (i32.mul (get_local $n) (i32.const 4)) (get_local $v)) (i32.const 42)) (export "setmem" (func $setmem)) (func $plusfive (param $n i32) (result i32) (i32.add (i32.const 5) (i32.load (i32.mul (get_local $n) (i32.const 4))))) (export "plusfive" (func $plusfive)))

