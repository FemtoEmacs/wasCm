# Low Level Lisp for WebAssembly

WebAssembly is a Instruction Set Architecture (ISA) for
a stack machine that can run in most modern browsers.
Therefore, WebAssembly allows the web designer to
customize the experience of the client, who is using
his or her browser to visit an Internet page. Besides
this, WebAssembly is blazing fast, when compared to
Javascript, the only other programming language that
the World Wide Web Consortium recommended to run natively
on Internet browsers.

## Reasons for using WebAssembly

One thing that makes WebAssembly exciting is the use of
the Cambridge Prefix Syntax, the same that makes Lisp
so interesting and powerful. Since Lisp is designed
to handle this kind of syntax, I invite you to help me
in the construction of a compiler, which translates
Low Level Lisp into WebAssembly. By using Lisp as the
implementation language, we can get the tokenizer and
the parser for free.

Implementing Lisp onto WebAssembly is so obvious that you
may wonder why somebody did not have this idea
long ago. In fact, a team at Google is working on
the implementation of Schism, a dialect of Lisp, on
WebAssembly. The members of this team intend to outfit
Schism with all powerful tools for list processing
and reflection that made Lisp famous. This is not what
the author of Low Level Lisp intends to do. The power
of Lisp comes with a price: Lisp compilers are very
difficult to implement. Compilers for Chez Scheme,
Bigloo, Racket, Gambit and Sbcl required years of
work from bright people, such as Manoel Serrano, Kent
Dybvig, Marc Feeley and Matthew Flatt.

I am fully aware that it would be difficult and unnecessary
to compete with the Google team that is constructing a
WebAssembly scheme. It will be unnecessary because they
will eventually succeed, and everybody will have another
open source Scheme dialect to use and deploy. However,
besides a high level language, such as Lisp or Prolog,
one needs low level languages to develop algorithms
for gaining a better understanding of the underlining
computer and performing things such as memory manipulation.

## Concise expressions

WebAssembly uses the Cambridge Prefix Notation, as Lisp,
but it does not accept those concise expressions, which
make Lisp programmers so productive. The idea is to design
a Low Level Lisp (LLL) compiler that accepts succinct
expressions, as in Scheme, but implement only those
operations that can be translated directly into WebAssembly.

Let us examine a concrete example. People often use a naive
definition of the Fibonacci's function to perform benchmarks.
In WebAssembly, such a definition is given below.

```Wasm
(func $fib (param $n i32) (result i32)
   (if (result i32)
     (i32.lt_s (get_local $n) (i32.const 2))
     (then (i32.const 1)) 
     (else (i32.add (call $fib (i32.sub (get_local $n)
                                    (i32.const 1)))
                    (call $fib (i32.sub (get_local $n) 
                                   (i32.const 2)))) )))
```

In Low Level Lisp, the same definition would not require
tags on constants or even on local variables, therefore it
could become compact and more to the point, as shown below.

```Scheme
(define (fib n)
   [if (<fx n 2) 1
       (+fx (fib (-fx n 2))
            (fib (-fx n 1))) ])
```

Although succinct, the Low Level Lisp definition
of naive Fibonacci has all the necessary elements
to reconstruct the wat `code`. For instance, since
the `-fx` function that performs fixed point
addition accepts only `i32` numbers, the Low
Level Lisp compiler can infer that the arguments
of `(-fx n 2)` should be `(get_local $n)`
and `(i32.const 2)`.

## Dynamic web pages

In a typical WebApplication, three languages would be
at play. On the server side, a Bigloo program would
take care of list processing and Artificial
Intelligence. On the browser, WebAssembly generated
by the LLL compiler would deal with text processing
and numerical calculations, while Javascript could
handle input output operations and insertion of
the LLL generated html snippets into the document.

In the documentation of this project, the interested
reader will find detailed descriptions of miniature
web pages designed pursuant to the LLL philosophy.
The documentation also provides a brief
tutorial of Bigloo, one of the languages supported
by Manoel Serrano's Hop web programming environment.
Finally, there is the ongoing work on an LLL compiler.

## Demos of simple programs
The first link shows the *greet* script, described in
chapter 9 of the documentation. 

http://medicina.tips/big/greet.k?xnome=%E9%82%93%E5%B0%8F%E5%B9%B3

The wasmdemo application is a very simple demonstration of how
to deploy a web page that loads an wasm program. This example
is discussed on chapter 4 of the documentation.

http://medicina.tips/big/wasmdemo.html

This demo shows a naive factorial benchmark that was programmed
in Low Level Lisp and compiled to wasm through the wasCm
compiler.

http://medicina.tips/big/nfib.html

## How to load html files
For security reasons, Firefox and other browsers do not
let you load local files containing Javascript code. To
enable JavaScript in local files follow the steps below:

- In Firefox, open up a new tab, and type about:config
  in the address bar, then press Enter
- Click the **accept-the-risk** button
- Type **unique** in the search box, then press **Enter**
- Switch the **privacy.file_unique_origin** preference to false


