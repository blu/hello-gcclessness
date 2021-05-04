#!/bin/bash

if [[ $HOSTTYPE == "armv7a" ]]; then
	root=/usr/local/root64
else
	root=/
fi
lib_path=$root/lib/aarch64-linux-gnu/:$root/usr/lib/aarch64-linux-gnu/
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as stringx.s -o stringx.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as stringlen.s -o stringlen.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as stringlen_1.s -o stringlen_1.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as stringlen_2.s -o stringlen_2.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as hello.s -o hello.o $@
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as stub.s -o stub.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-ld stringx.o hello.o libc/_itoa.o libc/itoa-digits.o libc/itoa-udigits.o stub.o -o hello
