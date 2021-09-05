#!/bin/bash

if [[ $HOSTTYPE == "armv7a" ]]; then
	root=/usr/local/root64
else
	root=/
fi
lib_path=$root/lib/aarch64-linux-gnu/:$root/usr/lib/aarch64-linux-gnu/
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as --strip-local-absolute stringx.s -o stringx.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as --strip-local-absolute hello_itoa.s -o hello_itoa.o $@
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as --strip-local-absolute stub.s -o stub.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-ld stringx.o hello_itoa.o libc/_itoa.o libc/itoa-digits.o libc/itoa-udigits.o stub.o -o hello_itoa
