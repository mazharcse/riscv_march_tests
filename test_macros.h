#*****************************************************************************
# test_macros.h
#-----------------------------------------------------------------------------
#

#ifndef _TEST_MACROS_H
#define _TEST_MACROS_H


/*
 * TEST_ADD(rd, a, b, expected)
 * - Safely loads a, b into t0, t1
 * - Performs rd = a + b
 * - Compares against expected
 */
#define TEST_ADD(rd, a, b, expected) \
  li  t0, a;                         \
  li  t1, b;                         \
  add rd, t0, t1;                    \
  li  t2, expected;                  \
  bne rd, t2, fail


  /*
 * TEST_SUB(rd, a, b, expected)
 * - Loads a, b into t0, t1
 * - Performs rd = a - b
 * - Compares result to expected
 */
#define TEST_SUB(rd, a, b, expected) \
  li  t0, a;                         \
  li  t1, b;                         \
  sub rd, t0, t1;                    \
  li  t2, expected;                  \
  bne rd, t2, fail



#define MARCH_TEST_CODE_BEGIN   \
    .section .text;         \
    .globl _start;        \
_start:                   

#define MARCH_TEST_CODE_END                                             \
    unimp;

#-----------------------------------------------------------------------
# Pass and fail code (assumes test num is in TESTNUM)
#-----------------------------------------------------------------------

#define TEST_PASSFAIL   \
        TEST_PASS;       \
fail:                   \
        TEST_FAIL;



#endif /* _TEST_MACROS_H */
