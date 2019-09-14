#!/bin/bash

root=/usr/local/root64
lib_path=$root/lib/aarch64-linux-gnu/:$root/usr/lib/aarch64-linux-gnu/
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as hello.s -o hello.o $@
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as stub.s -o stub.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-ld hello.o _itoa.o itoa-digits.o itoa-udigits.o stub.o -o hello
