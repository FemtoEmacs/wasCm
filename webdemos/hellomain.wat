(module
  (memory (export "memory") 1)
  (data (i32.const 1000) "Greetings from WebAssembly.")
  (data (i32.const 2000) "Hello, World!")
  (global (export "sz") i32 (i32.const 13))
  (global (export "pos") i32 (i32.const 1000)))  