#ifndef _TEST_MACROS_H
#define _TEST_MACROS_H

#include "march_test.h"


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

#endif /* _TEST_MACROS_H */
