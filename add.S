#*****************************************************************************
# add.S
#-----------------------------------------------------------------------------
#
# Test add instruction.
#

#include "test_macros.h"
#include "march_test.h"

MARCH_TEST_CODE_BEGIN 

    TEST_ADD(x5, 10, 20, 30)   # x5 = 10+20 = 30
    TEST_ADD(x6, -5, 5, 0)     # x6 = -5+5 = 0
    TEST_ADD(x7, 0, 0, 0)      # x7 = 0+0 = 0

    TEST_PASSFAIL

MARCH_TEST_CODE_END

loop:
    j loop


MARCH_TEST_DATA_BEGIN

MARCH_TEST_DATA_END



