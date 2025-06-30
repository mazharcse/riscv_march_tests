#*****************************************************************************
# sub.S
#-----------------------------------------------------------------------------
# Test sub instruction.

#include "test_macros.h"
#include "march_test.h"

MARCH_TEST_CODE_BEGIN

    TEST_SUB(x5, 10, 5, 5)     # 10 - 5 = 5
    TEST_SUB(x6, -5, -5, 0)    # -5 - (-5) = 0
    TEST_SUB(x7, 0, 10, -10)   # 0 - 10 = -10

    TEST_PASS

fail:
    TEST_FAIL

loop:
    j loop

MARCH_TEST_DATA_BEGIN
