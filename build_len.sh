#!/bin/bash

if [[ $HOSTTYPE == "armv7a" ]]; then
	root=/usr/local/root64
else
	root=/
fi
lib_path=$root/lib/aarch64-linux-gnu/:$root/usr/lib/aarch64-linux-gnu/
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as --strip-local-absolute stringlen.s   -o stringlen.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as --strip-local-absolute stringlen_1.s -o stringlen_1.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as --strip-local-absolute stringlen_2.s -o stringlen_2.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as --strip-local-absolute stringlen_3.s -o stringlen_3.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as --strip-local-absolute stringlen_4.s -o stringlen_4.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as --strip-local-absolute stringlen_5.s -o stringlen_5.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as --strip-local-absolute stringlen_6.s -o stringlen_6.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as --strip-local-absolute stringlen_7.s -o stringlen_7.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as --strip-local-absolute stringlen_8.s -o stringlen_8.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as --strip-local-absolute stringlen_9.s -o stringlen_9.o
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-as --strip-local-absolute hello_len.s -o hello_len.o $@
LD_LIBRARY_PATH=$lib_path $root/lib/ld-linux-aarch64.so.1 $root/usr/bin/aarch64-linux-gnu-ld stringlen.o stringlen_1.o stringlen_2.o stringlen_3.o stringlen_4.o stringlen_5.o stringlen_6.o stringlen_7.o stringlen_8.o stringlen_9.o hello_len.o libc/strlen_generic.o libc/strlen_asimd.o -o hello_len
