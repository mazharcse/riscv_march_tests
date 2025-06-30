#include "test_macros.h"

.section .text
.global _start
_start:
    TEST_ADD(x5, 10, 20, 30)   # x5 = 10+20 = 30
    TEST_ADD(x6, -5, 5, 0)     # x6 = -5+5 = 0
    TEST_ADD(x7, 0, 0, 0)      # x7 = 0+0 = 0

    TEST_PASS

fail:
    TEST_FAIL

loop:
    j loop

.section .data
.align 3
.global tohost
tohost: .dword 0

.align 3
.global fromhost
fromhost: .dword 0

