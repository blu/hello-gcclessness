# hello-gcclessness
What do you do when you're on vacation and you're left without a compiler?

Fall back to `as` and `ld`, of course.

# building
The build script works on native aarch64 as well as on a specific arm64-deb-packages-over-armhf-userspace setup.

	$ ./build.sh # for string_xNN  
	$ ./build.sh --defsym test_itoa=1 # for libc _itoa_word

# benchmarking
All data in L1 cache, optimal alignment:

| uarch/function                         | total time for 2^28 funcalls | Mfuncall/s | Mchar/s | clk/char |
| -------------------------------------- | ---------------------------- | ---------- | ------- | -------- |
| **string_x16** : 16-bit hex to string  |                              |            |         |          |
| Cortex-A72 @2.1GHz                     | 0m1.662s                     |  162       |   646   |  3.25    |
| Cortex-A72 @2.0GHz                     | 0m1.746s                     |  154       |   615   |  3.25    |
| Cortex-A73 @1.8GHz                     | 0m2.317s                     |  116       |   463   |  3.88    |
| Cortex-A53 @1.5GHz                     | 0m3.582s                     |   75       |   300   |  5.00    |
| Cortex-A53 @1.7GHz                     | 0m3.162s                     |   85       |   340   |  5.01    |
| Cortex-A76 @3.0GHz                     | 0m0.901s                     |  298       |  1192   |  2.52    |
| Firestorm @3.2GHz                      | 0m0.394s                     |  681       |  2725   |  1.17    |
| **string_x16_2** : asimd version       |                              |            |         |          |
| Cortex-A72 @2.1GHz                     | 0m1.155s                     |  232       |   930   |  2.26    |
| Cortex-A73 @1.8GHz                     | 0m1.645s                     |  163       |   653   |  2.76    |
| Cortex-A53 @1.7GHz                     | 0m3.160s                     |   85       |   340   |  5.00    |
| Cortex-A76 @3.0GHz                     | 0m0.582s                     |  461       |  1845   |  1.63    |
| Firestorm @3.2GHz                      | 0m0.283s                     |  949       |  3794   |  0.84    |
| **string_x32** : 32-bit hex to string  |                              |            |         |          |
| Cortex-A72 @2.1GHz                     | 0m1.152s                     |  233       |  1864   |  1.13    |
| Cortex-A73 @1.8GHz                     | 0m1.645s                     |  163       |  1305   |  1.38    |
| Cortex-A53 @1.7GHz                     | 0m3.163s                     |   85       |   679   |  2.50    |
| Cortex-A76 @3.0GHz                     | 0m0.583s                     |  460       |  3684   |  0.81    |
| Firestorm @3.2GHz                      | 0m0.293s                     |  916       |  7329   |  0.44    |
| **string_x64** : 64-bit hex to string  |                              |            |         |          |
| Cortex-A72 @2.1GHz                     | 0m1.361s                     |  197       |  3156   |  0.67    |
| Cortex-A73 @1.8GHz                     | 0m1.794s                     |  150       |  2394   |  0.75    |
| Cortex-A53 @1.7GHz                     | 0m3.792s                     |   71       |  1133   |  1.50    |
| Cortex-A76 @3.0GHz                     | 0m0.582s                     |  461       |  7380   |  0.41    |
| Firestorm @3.2GHz                      | 0m0.291s                     |  922       | 14759   |  0.22    |
| **string_x64_1** : alt scheduling      |                              |            |         |          |
| Cortex-A72 @2.1GHz                     | 0m1.373s                     |  196       |  3128   |  0.67    |
| Cortex-A73 @1.8GHz                     | 0m1.794s                     |  150       |  2394   |  0.75    |
| Cortex-A53 @1.7GHz                     | 0m3.634s                     |   74       |  1182   |  1.44    |
| Cortex-A76 @3.0GHz                     | 0m0.581s                     |  462       |  7392   |  0.41    |
| Firestorm @3.2GHz                      | 0m0.292s                     |  919       | 14709   |  0.22    |

In comparison, libc-2.27 **\_itoa_word** [^1] performance:

| uarch/function                         | total time for 2^28 funcalls | Mfuncall/s | Mchar/s | clk/char |
| -------------------------------------- | ---------------------------- | ---------- | ------- | -------- |
| **\_itoa_word** : 16-bit hex to string |                              |            |         |          |
| Cortex-A72 @2.1GHz                     | 0m2.685s                     |  100       |  400    |  5.25    |
| **\_itoa_word** : 32-bit hex to string |                              |            |         |          |
| Cortex-A72 @2.1GHz                     | 0m3.705s                     |   72       |  580    |  3.62    |
| **\_itoa_word** : 64-bit hex to string |                              |            |         |          |
| Cortex-A72 @2.1GHz                     | 0m5.490s                     |   49       |  782    |  2.68    |

[^1]: libc inner implementation of **itoa**, sans stack guards and fail checks. Uses LUTs and supports upper- and lower-case translations.
