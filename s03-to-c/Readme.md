# A scheme to C compiler
This compiler is a proof of the concept that you can write
a web application in Scheme and compile it to wasm, so users
can run it in their browsers. In order to use this Scheme to
C compiler, you will need the Emscripten toolchain and the
Bigloo compiler. You can also generate code for your local
or cloud machine; in this case, you will need a gcc compiler,
instead of the Emscripten toolchain. This proof of concept
aims at convincing Scheme developpers to

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
