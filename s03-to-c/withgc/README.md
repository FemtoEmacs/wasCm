# Steps to build the Garbage Collector

The first thing we should do is to organize
our workspace. Here is what I did: I created
a user for **Scheme**. Therefore, everything
that deals with **Scheme** is in the scm `HOME`,
which is in the `/home/scm` folder. If I check
the `HOME` variable, I get the following result:

```Shell

~/wrk/scm2c/withgc$ cd
~$ echo $HOME
/home/scm
~$ mkdir wrk
~$ cd wrk
~/wrk$ mkdir gc
~/wrk$ cd gc
~/wrk/gc$ mv ~/Downloads/gc-8.0.4.tar.gz .
~/wrk/gc$ ls
gc-8.0.4.tar.gz

```

Now, everything is in place, and you can proceed
to build the Boehm Garbage Collector.

## Installing the Boehm gc

If you configure the Boehm garbage collector with the
option `./configure --prefix=$HOME/wrk/gc` that you
can see below, the libraries and include files of the
garbage collector will be placed it the `~/wrk/gc`
folder that you created to hold them. The scripts
that I wrote to build scheme programs are based on
the premisses that the Boehm garbage collector was 
installed in the `~/wrk/gc` folder.

```Shell

~/wrk/gc$ tar xfz gc-8.0.4.tar.gz  # Unpack the distro
~/wrk/gc$ cd gc-8.0.4/  # Enter the directory
~/wrk/gc/gc-8.0.4$ ./configure --prefix=$HOME/wrk/gc

~/wrk/gc/gc-8.0.4$ make
~/wrk/gc/gc-8.0.4$ make install
~/wrk/gc/gc-8.0.4$ cd ..
~/wrk/gc$ ls
gc-8.0.4  gc-8.0.4.tar.gz  include  lib  README.md  share
~/wrk/gc$ cd ../scm2c/gc/  # Go back to the scheme directory

```



