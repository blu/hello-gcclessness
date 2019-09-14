# hello-gcclessness
What do you do when you're on vacation and you're left without a compiler?

Fall back to `as` and `ld`, of course.

# building
The build script is for reference and not for common use, unless you're running a very specialized arm64-deb-packages-over-chromeos-armhf setup.

# benchmarking
All data in L1 caches, optimal alignment:

| uarch/function                         | total time for 2^28 funcalls | funcall/s | chars/s   | clocks/char |
| -------------------------------------- | ---------------------------- | --------- | --------- | ----------- |
| **string_x16** : 16-bit hex to string  |                              |           |           |             |
| Cortex-A72 @2.1GHz                     | 0m1.662s                     | 162M      |  646M     | 3.25        |
| Cortex-A72 @2.0GHz                     | 0m1.746s                     | 154M      |  615M     | 3.25        |
| Cortex-A53 @1.5GHz                     | 0m3.582s                     |  75M      |  300M     | 5.00        |
| **string_x32** : 32-bit hex to string  |                              |           |           |             |
| Cortex-A72 @2.1GHz                     | 0m2.301s                     | 117M      |  933M     | 2.25        |
| Cortex-A72 @2.0GHz                     | 0m2.414s                     | 111M      |  890M     | 2.25        |
| Cortex-A53 @1.5GHz                     | 0m3.590s                     |  75M      |  598M     | 2.51        |
| **string_x64** : 64-bit hex to string  |                              |           |           |             |
| Cortex-A72 @2.1GHz                     | 0m2.462s                     | 109M      | 1745M     | 1.20        |
| Cortex-A72 @2.0GHz                     | 0m2.585s                     | 104M      | 1661M     | 1.20        |
| Cortex-A72 @1.8GHz                     | 0m2.875s                     |  93M      | 1494M     | 1.20        |
| Cortex-A73 @1.8GHz                     | 0m1.794s                     | 150M      | 2394M     | 0.75        |
| Cortex-A53 @1.5GHz                     | 0m4.300s                     |  62M      |  999M     | 1.50        |
| **string_x64_1** : alt scheduling      |                              |           |           |             |
| Cortex-A72 @2.1GHz                     | 0m2.422s                     | 111M      | 1773M     | 1.18        |
| Cortex-A72 @2.0GHz                     | 0m2.552s                     | 105M      | 1683M     | 1.19        |
| Cortex-A53 @1.7GHz                     | 0m3.637s                     |  74M      | 1181M     | 1.44        |
| Cortex-A53 @1.5GHz                     | 0m4.116s                     |  65M      | 1043M     | 1.44        |

In comparison, libc-2.27 **\_itoa_word** [^1] performance:

| uarch                                  | total time for 2^28 funcalls | funcall/s | chars/s   | clocks/char |
| -------------------------------------- | ---------------------------- | --------- | --------- | ----------- |
| **\_itoa_word** : 16-bit hex to string |                              |           |           |             |
| Cortex-A72 @2.1GHz                     | 0m2.685s                     | 100M      | 400M      | 5.25        |
| **\_itoa_word** : 32-bit hex to string |                              |           |           |             |
| Cortex-A72 @2.1GHz                     | 0m3.705s                     |  72M      | 580M      | 3.62        |
| **\_itoa_word** : 64-bit hex to string |                              |           |           |             |
| Cortex-A72 @2.1GHz                     | 0m5.490s                     |  49M      | 782M      | 2.68        |

[^1]: libc inner implementation of **itoa**, sans stack guards and fail checks. Uses LUTs and supports upper- and lower-case translations.
