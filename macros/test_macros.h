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
    .section .text;             \
    .globl _start;              \
_start:

#define MARCH_TEST_CODE_END                                             \
    unimp;

#define INIT_SELF_CHECK_LOOP \
    li x15, 0;              /* index */ \
    li x16, 16;             /* total elements */ \
    la x17, result;         /* result array */ \
    la x18, expected       /* expected array */

#define SELF_CHECK_LOOP \
check_loop: \
    ld x19, 0(x17); \
    ld x20, 0(x18); \
    bne x19, x20, fail; \
    addi x17, x17, 8; \
    addi x18, x18, 8; \
    addi x15, x15, 1; \
    blt x15, x16, check_loop


#-----------------------------------------------------------------------
# Pass and fail code (assumes test num is in TESTNUM)
#-----------------------------------------------------------------------

#define TEST_PASSFAIL   \
        TEST_PASS;       \
fail:                   \
        TEST_FAIL;

#define PASS_FAIL_HANDLERS \
pass: \
    li x31, 1  ;          /* Set x31 to success code */ \
    la x24, tohost; \
    j done; \
\
fail: \
    li x31, -1;           /* Set x31 to failure code */ \
    la x24, tohost; \
    j hang; \
\
done: \
    sw x31, 0(x24) ;      /* Write result to tohost */ \
    cbo.flush 0(x24);     /* Ensure write is committed */ \
    j done;               /* Infinite loop */ \
\
hang: \
    sw x31, 0(x24);       /* Write result to tohost */ \
    cbo.flush 0(x24);     /* Ensure write is committed */ \
    j hang;               /* Infinite loop */


#define CONTEXT_SWITCH_TEST \
    li x11, 32; \
    vsetvli x0, x11, e64, m1; \
    la x12, input1; \
    la x13, input2; \
    la x14, result; \
    vle64.v v1, (x12); \
    vle64.v v2, (x13); \
    vdiv.vv v3, v1, v2; \
    vmulhsu.vv v1, v3, v2; \
    vrem.vv v2, v1, v2; \
    vnmsac.vv v3, v1, v2; \
    vredsum.vs v4, v3, v1; \
    vdiv.vv v3, v3, v4; \
    vse64.v v3, (x14)

#define STRESS_TEST \
    la a0, input1; \
    la a1, input2; \
    la a2, result; \
    li x3, 128; \
    vsetvli x4, x3, e16, m1; \
    vxor.vv v3, v3, v3; \
    vle16.v v4, (a0); \
    vle16.v v2, (a1); \
    li x1, 500; \
    loop_wide: \
        vwmul.vv v0, v4, v2; \
        vwadd.vv v2, v1, v0; \
        addi x1, x1, -1; \
        bnez x1, loop_wide; \
    li x1, 500; \
    loop_single_wide: \
        vadd.vv v3, v4, v2; \
        addi x1, x1, -1; \
        bnez x1, loop_single_wide; \
    li x1, 500; \
    loop_wide_repeat: \
        vwmul.vv v0, v4, v2; \
        vwadd.vv v2, v1, v0; \
        addi x1, x1, -1; \
        bnez x1, loop_wide_repeat; \
    li x1, 500; \
    loop_single_wide_repeat: \
        vadd.vv v3, v4, v2; \
        addi x1, x1, -1; \
        bnez x1, loop_single_wide_repeat; \
    vse16.v v3, (a2)


#endif /* _TEST_MACROS_H */
