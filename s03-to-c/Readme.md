# A scheme to C compiler
This compiler is a proof of the concept that you can write
a web application in Scheme and compile it to wasm, so users
can run it in their browsers. In order to use this Scheme to
C compiler, you will need the Emscripten tool chain and the
Bigloo compiler. You can also generate code for your local
or cloud machine; in this case, you will need a gcc compiler,
instead of the Emscripten tool chain. This proof of concept
aims at convincing Scheme developers to port their compilers
to WebAssembly through the Emscripten tool chain.

Let us see how this compiler works. From the `s03-to-c`
folder, start bigloo, as shown on the first line of the
listing below. Then, load the Scheme to C compiler, and
compile one of the many snippets that are provided in
the `s03-to-c` folder. Finally, exit *bigloo* and build
the resulting C program through the emcc compiler or the
gcc compiler. In the case you use emcc, your code is ready
for distribution through the web. 

```Shell

~/wrk/s03-to-c$ rlwrap bigloo -s

1:=> (load "scm2c.sch")
scm2c.sch
1:=> (compit "examples/ofib.scm" "ofib.c")
#<output_port:ofib.c>
1:=> (exit)
~/wrk/s03-to-c$ emcc -O3 ofib.c -o ofib.js
~/wrk/s03-to-c$ node ofib.js
165580141
~/wrk/s03-to-c$ ls -lia ofib.*
39724413 -rw-r--r-- 1 scm scm 14877 mai 22 17:53 ofib.c
 8652330 -rw-r--r-- 1 scm scm 16449 mai 22 17:54 ofib.js
 8652313 -rw-r--r-- 1 scm scm 23055 mai 22 17:54 ofib.wasm

```

Let me tell the story of the Scheme to C compiler. On may
2020, I was stuck at home due the COVID-19 pandemic. Then,
I decided to port my web page to WebAssembly. However, I
discovered that there was no Scheme compiler, which I could
use to generate code, which would be compact enough for web
distribution. Then, I contacted Manoel Serrano, the main
developer of the Bigloo compiler, and asked for a port to
the Emscripten tool chain. While Serrano was trying to squeeze
some time from busy agenda, I decided to code a proof of
concept of a browser Scheme Lisp.

## Features of a browser Lisp
A browser Lisp must have can do without many features,
such as input/output or speed, but must have a small
footprint and generate small executable files, that can
make good use of the available bandwidth. As you can see,
the executable file that resulted from the `ofib.scm`
snippet occupies less than 40 K bytes. 

The compiler was build in three days. It was based in a
blog by Matthew Might about how to compile Scheme to C
through closure conversion.

http://matt.might.net/articles/compiling-scheme-to-c/

The article is very interesting, as all Matthew's articles
are, however it leaves out of the discussion many important
aspects of Scheme implementation. For instance, there is
not a single word about Tail Call Optimization (TCO), which
is the way Scheme performs loops and iterations. Without TCO,
there is no loop. You certainly will advise me to send an
email to Matthew Might asking about TCO, lists, logical
forms, floating point, garbage collector and all other
tools that are missing in his proposal of a Scheme to C
compiler. In fact, the only thing that Matthew Might
implemented was closures.


## Matthew Might

I thought about sending an email to Matthew Might myself,
and even wrote a careful designed email to get his attention.
Then, I discovered that Matthew Might is what people call
a renowned and popular person. His became a pioneer in
Precision Medicine almost by accident: His son Bertrand was
born with an undiagnosed genetic disorder. Matthew decided to
fight his fate with the only weapon he had in hands -- Computer
Science. As far as I understood, the distressed father perfected
MiniKanren, a very famous Scheme program, in order to transform
it into MediKanren, which scanned human genome, in order to
find the defective genes that Bertrand inherited from his
parents, Cristina and Matthew. 

https://www.uab.edu/news/research/item/10382-a-high-speed-dr-house-for-medical-breakthroughs

The efforts of Matthew Might to save his son did not go
unappreciated. He was appointed White House strategist
for the Precision Medicine Initiative by former President
Obama, and confirmed in the position by Donald Trump.
He became visiting professor in Harvard, professor of
Internal Medicine in the University of Alamba, and professor
of pharmacology and computer science at the University of
Utah. After seeing how busy schedule Matthew Might has,
I gave up sending an email about Tail Call Optimization.
By the way, Matthew Might wrote an email about sending
and replying to emails. According to Matthew Might
recommendations, one should not send emails asking why
code does not work. See it by yourself:

http://matt.might.net/articles/how-to-email/

## Tail Call Optimization
In order to find a short term solution to the problem
of Tail Call Opitimization, I wrote a primitive function
manager for the Scheme to C compiler. Primitive functions
are those procedures that are part of the runtime of the
language, therefore, the programmer do not need to code,
for instance, the arithmetic operations. The primitive
function manager do have Tail Call Optimization. Therefore,
if you need to iterate 1 million times, all you need to do
is to program tho loop as primitive function. You will find
a few examples of primitive functions in the `prelude.sch`
file, which I reproduce below for ready reference.

```Scheme
[primitives

  (define (top e sexpr)
     (car sexpr))

  (define (rest e sexpr)
     (cdr sexpr))

  (define (floopsum e ix sx facc)
    (if (null? sx) facc
        (floopsum e (- ix 1) (cdr sx)
              (+ (f(car sx)) facc)) ))

  (define (floop e ix fy)
      (if (< ix 1) fy
          (floop e (- ix 1) (+ fy 0.1)) ))

  (define (fadd e fx fy)
     (+ fx fy))

  (define (mcons e xs)
    (cons (iexpr 42) xs))

];; end primitives

```

A primitive function has no closure, therefore, it is easy to
implement Tail Call Optimization. In fact, the primitive function
inherits Tail Call Optimization from C. The syntax of a primitive
is very similar to the normal Scheme function, but there are a
few differences that you should take into account. Identifiers
that start with i, j and k are integers, while those starting
with f, g and h are floating point. All other identifiers have
the normal Lisp sexpr type (Symbolic Expression). Besides this,
since a primitive function is not a closure, it must carry its
environment in the first argument. In the case of the `floop`
function, the environment is represented by the *e* variable.
Below, you will find the Scheme function that calls `floop`,
which is it the `examples/test17.scm` file.


```Scheme

;;; File: examples/test17.scm

(letrec
    [(xx 42.0)]
  (begin (display (fadd xx 12.5))
     (display (floop 1000000 0.0)) ))

```

I hope that Manoel Serrano, the author of Bigloo, help me
in finding a better solution to the problem of Tail Call
optimization. Since the Scheme to C compiler generates the
gcc dialect of C, which does have Tail Call Optimization,
I believe that the problem of implementing TCO will not be
very difficult to solve.

## Features of the Scheme to C compiler

The original compiler discussed in Matthew's blog implements
integers and four primitive functions: sum, difference,
product, equality, all for integers. I added sexpr (cons cells),
floating point, chars and strings. I also wrote a display
function that can print all these types. For each of these
types, I created the appropriate functions:

- Integer numbers: `> < >= <= = + - / * quot mod`

- Floating Point numbers: `>. <. >=. <=. =. +. -. /. *`.

- Chars: `char=? char<? char>? char>=? char<=? char~=?`

- Strings: `string-ref string-set! strcat string=? string>? string<?`

- Logic: `&& (and), // (or), cond`

- Lists: `car cdr cons pair? null?`

- Primitive functions: `car cdr cons`

- `(f sx)` - converts `sx` from Lisp float to C float

- `(i sx)` - converts `sx` from Lisp integer to C interger

- `(iexpr ix) - converts `ix` from C integer to Lisp integer

- `(fexpr fx)` - converts `fx` from C flot to Lisp float

Let us see an example of the necessity of these conversions.
Lists use the same selectors and constructor both in Lisp
and in C, which are `cdr`, `car` and `cons`. In the function
below, in order to insert the C integer 42 into a Lisp list,
I must use `iexpr` to convert it to the Lisp sexpr type.


```Scheme

  (define (mcons e xs)
    (cons (iexpr 42) xs))

```

The programa below performs the addition of all elements
of the list `sx`. In order to add the `(car sx)` to the
accumulator `facc`, I need to convert it to a C type,
which is accomplished by the `f` function.

```Scheme

  (define (floopsum e ix sx facc)
    (if (null? sx) facc
        (floopsum e (- ix 1) (cdr sx)
              (+ (f(car sx)) facc)) ))

```


