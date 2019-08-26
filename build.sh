#!/bin/bash

lib_path=/usr/local/root64/lib/aarch64-linux-gnu/:/usr/local/root64/usr/lib/aarch64-linux-gnu/
LD_LIBRARY_PATH=$lib_path ../lib/aarch64-linux-gnu/ld-2.23.so ../usr/bin/aarch64-linux-gnu-as hello.s -o hello.o
LD_LIBRARY_PATH=$lib_path ../lib/aarch64-linux-gnu/ld-2.23.so ../usr/bin/aarch64-linux-gnu-ld hello.o -o hello
