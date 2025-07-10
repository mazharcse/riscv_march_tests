#*****************************************************************************
# context_switch.S
#-----------------------------------------------------------------------------
#
# Test context switch instruction.
#

#include "test_macros.h"
#include "march_test.h"

MARCH_TEST_CODE_BEGIN
    
    SET_MACHINE_STATUS
   

    CONTEXT_SWITCH_TEST


    # Self-check loop     
    INIT_SELF_CHECK_LOOP
    SELF_CHECK_LOOP

PASS_FAIL_HANDLERS

MARCH_TEST_DATA_SECTION
