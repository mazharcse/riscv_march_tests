#*****************************************************************************
# march_test.h
#-----------------------------------------------------------------------------


#ifndef _MARCH_TEST_H
#define _MARCH_TEST_H

#define TEST_PASS \
  la x1, tohost;  \
  li x2, 1;       \
  sd x2, 0(x1);   \
  fence;          \
  j loop

#define TEST_FAIL \
  la x1, tohost;  \
  li x2, 0xdead;  \
  sd x2, 0(x1);   \
  fence;          \
  j loop

#define MARCH_TEST_DATA_BEGIN   \
    .section .data;              \
    .align 3     ;               \
    .global tohost;              \
    tohost: .dword 0 ;           \
                                \
    .align 3          ;          \
    .global fromhost   ;         \
    fromhost: .dword 0;

#define MARCH_TEST_DATA_END .align 3; .global end_signature; end_signature:

#endif /* _MARCH_TEST_H */
