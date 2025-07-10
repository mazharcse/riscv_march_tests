#*****************************************************************************
# stress.S
#-----------------------------------------------------------------------------
#
# Test stress instruction.
#

#include "test_macros.h"
#include "march_test.h"

MARCH_TEST_CODE_BEGIN
    
    SET_MACHINE_STATUS

    STRESS_TEST

     # Self-check loop     
    INIT_SELF_CHECK_LOOP
    SELF_CHECK_LOOP

PASS_FAIL_HANDLERS

MARCH_TEST_DATA_SECTION
