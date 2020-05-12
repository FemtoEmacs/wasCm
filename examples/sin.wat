(module (func
         $sine
         (param $a f64)
         (result f64)
         (local $c0 f64)
         (local $c1 f64)
         (local $c2 f64)
         (local $c3 f64)
         (local $c4 f64)
         (local $c5 f64)
         (local $pi f64)
         (local $mi f64)
         (local $xx f64)
         (local $puu f64)
         (local $p9 f64)
         (local $p7 f64)
         (local $p5 f64)
         (local $p3 f64)
         (local $p1 f64)
         (block (result f64)
                (set_local $c0 (f64.const -0.10132118))
                (set_local $c1 (f64.const 0.0066208798))
                (set_local $c2 (f64.const -0.00017350505))
                (set_local $c3 (f64.const 0.0000025222919))
                (set_local $c4 (f64.const -2.3317787e-8))
                (set_local $c5 (f64.const 1.3291342e-10))
                (set_local $pi (f64.const 3.1415927))
                (set_local $mi (f64.const -8.742278e-8))
                (set_local
                  $xx
                  (f64.mul (get_local $a) (get_local $a)))
                (set_local $puu (get_local $c5))
                (set_local
                  $p9
                  (f64.add
                    (f64.mul (get_local $puu) (get_local $xx))
                    (get_local $c4)))
                (set_local
                  $p7
                  (f64.add
                    (f64.mul (get_local $p9) (get_local $xx))
                    (get_local $c3)))
                (set_local
                  $p5
                  (f64.add
                    (f64.mul (get_local $p7) (get_local $xx))
                    (get_local $c2)))
                (set_local
                  $p3
                  (f64.add
                    (f64.mul (get_local $p5) (get_local $xx))
                    (get_local $c1)))
                (set_local
                  $p1
                  (f64.add
                    (f64.mul (get_local $p3) (get_local $xx))
                    (get_local $c0)))
                (f64.mul
                  (f64.sub
                    (get_local $a)
                    (f64.sub (get_local $pi) (get_local $mi)))
                  (f64.mul
                    (f64.add
                      (get_local $a)
                      (f64.add (get_local $pi) (get_local $mi)))
                    (f64.mul (get_local $p1) (get_local $a))))))
  (export "sine" (func $sine))
  (func $sin
        (param $a f64)
        (result f64)
        (local $pi f64)
        (local $pii f64)
        (block (result f64)
               (set_local $pi (f64.const 3.14159265))
               (set_local
                 $pii
                 (f64.mul (get_local $pi) (get_local $pi)))
               (f64.div
                 (f64.mul
                   (f64.const 16.0)
                   (f64.mul
                     (get_local $a)
                     (f64.sub (get_local $pi) (get_local $a))))
                 (f64.sub
                   (f64.mul (f64.const 5.0) (get_local $pii))
                   (f64.mul
                     (f64.const 4.0)
                     (f64.mul
                       (f64.sub (get_local $pi) (get_local $a))
                       (get_local $a)))))))
  (export "sin" (func $sin)))



