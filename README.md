# hello-gcclessness
Miscellaneous utilities modeled after libc such. All string\*.s routines are AAPCS64-compliant and ready for linking against c++ code via

	extern "C" void name(args..) asm ("asm_name");

# building the benchmark
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
| Cortex-A73 @2.55GHz                    | 0m1.633s                     |  164       |   658   |  3.88    |
| Cortex-A53 @1.5GHz                     | 0m3.582s                     |   75       |   300   |  5.00    |
| Cortex-A53 @1.7GHz                     | 0m3.162s                     |   85       |   340   |  5.01    |
| Cortex-A76 @3.0GHz                     | 0m0.894s                     |  300       |  1201   |  2.50    |
| Firestorm @3.2GHz                      | 0m0.362s                     |  742       |  2966   |  1.08    |
| **string_x16_2** : asimd version       |                              |            |         |          |
| Cortex-A72 @2.1GHz                     | 0m1.155s                     |  232       |   930   |  2.26    |
| Cortex-A73 @1.8GHz                     | 0m1.645s                     |  163       |   653   |  2.76    |
| Cortex-A73 @2.55GHz                    | 0m1.167s                     |  230       |   920   |  2.77    |
| Cortex-A53 @1.7GHz                     | 0m3.160s                     |   85       |   340   |  5.00    |
| Cortex-A76 @3.0GHz                     | 0m0.570s                     |  471       |  1884   |  1.59    |
| Firestorm @3.2GHz                      | 0m0.253s                     | 1061       |  4244   |  0.75    |
| **string_x32** : 32-bit hex to string  |                              |            |         |          |
| Cortex-A72 @2.1GHz                     | 0m1.152s                     |  233       |  1864   |  1.13    |
| Cortex-A73 @1.8GHz                     | 0m1.645s                     |  163       |  1305   |  1.38    |
| Cortex-A73 @2.55GHz                    | 0m1.164s                     |  231       |  1845   |  1.38    |
| Cortex-A53 @1.7GHz                     | 0m3.163s                     |   85       |   679   |  2.50    |
| Cortex-A76 @3.0GHz                     | 0m0.570s                     |  471       |  3768   |  0.80    |
| Firestorm @3.2GHz                      | 0m0.253s                     | 1061       |  8488   |  0.38    |
| **string_x64** : 64-bit hex to string  |                              |            |         |          |
| Cortex-A72 @2.1GHz                     | 0m1.360s                     |  197       |  3158   |  0.66    |
| Cortex-A73 @1.8GHz                     | 0m1.794s                     |  150       |  2394   |  0.75    |
| Cortex-A73 @2.55GHz                    | 0m1.262s                     |  213       |  3403   |  0.75    |
| Cortex-A53 @1.7GHz                     | 0m3.792s                     |   71       |  1133   |  1.50    |
| Cortex-A76 @3.0GHz                     | 0m0.569s                     |  472       |  7548   |  0.40    |
| Firestorm @3.2GHz                      | 0m0.253s                     | 1061       | 16976   |  0.19    |
| NV Carmel @1.907GHz                    | 0m0.145s [^2]                | 1851       | 29620   |  0.06    |
| **string_x64_1** : alt scheduling      |                              |            |         |          |
| Cortex-A72 @2.1GHz                     | 0m1.372s                     |  196       |  3130   |  0.67    |
| Cortex-A73 @1.8GHz                     | 0m1.794s                     |  150       |  2394   |  0.75    |
| Cortex-A73 @2.55GHz                    | 0m1.270s                     |  211       |  3382   |  0.75    |
| Cortex-A53 @1.7GHz                     | 0m3.633s                     |   74       |  1182   |  1.44    |
| Cortex-A76 @3.0GHz                     | 0m0.569s                     |  472       |  7548   |  0.40    |
| Firestorm @3.2GHz                      | 0m0.253s                     | 1061       | 16976   |  0.19    |

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
[^2]: **The curious case of NV Carmel** This uarch deserves an elaboration. It's an armv8.2-a frontend to a custom NV VLIW uarch, employing a JIT **optimising** binary translator for repeat runs of the same code. My first reaction seeing the results, based on prior experience with Carmel benchmarks, was 'The translator must be seeing that the input to the many-invocations routine is an immediate, so the translator optimizes out the multiple invocations down to one invocation, followed by multiple writes of the result to the output address.' That led me to engage in a game of cat-and-mouse with the JIT translator. First, I took the input value out of the instruction stream and into a literal pool -- no change. Next thought: 'So the translator sees it's a .text-section (i.e. read-only) literal and still does its optimisation.' That got me slighly worried, as that could potentially break some corner cases where an MT code would use writable mapping of a .text section. Next I put the input value in the .data section -- no change. At that stage I was properly worried that the translator might be way too aggressive -- ignoring multiple reads from the same .data address could really break MT code. To verify that I went MT where a dedicated thread would update the .data address periodically, while the testee routine would get fed from that address as an input. To my relief the testee did pick up the newly-updated values, but the times stayed the same! That dispelled my suspicion and allowed me to accept the observed results at face value. So what do they mean? The quoted 0.06 clocks/character are a tad inconvenient here, so let's use its reciprocal of 15.53 chars/clock. That's ~16 bytes/clock -- the width of an aarch64 SIMD register, and coincidentally, the size of a hex string from an 8-byte input. Or put in other words, Carmel is capable of one 64-bit hex-to-ascii conversion **per clock** -- that's quite some throughput! Could the translator still be optimizing something the rest of the uarchs don't? -- Sure, for one, the constants loads at the start of the routine could be moved out of the testee loop. But that's a valid use case and something any compiler would do when inlining a routine inside a tight loop. So there's that -- if anything, that VLIW uarch is the ideal platform for this code -- no other uarch reaches that throughput. Kudos to NV's Carmel team!
