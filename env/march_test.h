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

#define SET_MACHINE_STATUS \
  li x1, 0x02200; \
  csrs mstatus, x1

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

#define MARCH_TEST_DATA_SECTION \
    .section .data; \
input1: \
    .dword 0x8000000000000000, 0x7fffffffffffffff, 0x00000000ffffffff, 0xffffffff00000000; \
    .dword 0xaaaaaaaaaaaaaaaa, 0x5555555555555555, 0x0f0f0f0f0f0f0f0f, 0xf0f0f0f0f0f0f0f0; \
    .dword 0x13579bdf2468ace0, 0x2468ace013579bdf, 0x000000000000dead, 0x00000000badc0ffe; \
    .dword 0x0123456789abcdef, 0xfedcba9876543210, 0xdeadbeefdeadbeef, 0x0000000000000001; \
    .dword 0xfffffffffffffffe, 0x1111111111111111, 0x2222222222222222, 0x3333333333333333; \
    .dword 0x4444444444444444, 0x8888888888888888, 0x9999999999999999, 0xbbbbbbbbbbbbbbbb; \
    .dword 0xcccccccccccccccc, 0xdddddddddddddddd, 0xeeeeeeeeeeeeeeee, 0x1234567812345678; \
    .dword 0x9999999999999999, 0x0000000000000000, 0xffffffffffffffff, 0x7fffffffffffffff; \
input2: \
    .dword 0x7fffffffffffffff, 0x0000000000000001, 0xffffffff00000000, 0x00000000ffffffff; \
    .dword 0x5555555555555555, 0xaaaaaaaaaaaaaaaa, 0xf0f0f0f0f0f0f0f0, 0x0f0f0f0f0f0f0f0f; \
    .dword 0xdeadbeefdeadbeef, 0x89abcdef01234567, 0x0000000000002152, 0xffffffffdeadbeef; \
    .dword 0x89abcdef01234567, 0x76543210fedcba98, 0x0000000000000001, 0xffffffffffffffff; \
    .dword 0x0000000000000001, 0xeeeeeeeeeeeeeeee, 0xdddddddddddddddd, 0xcccccccccccccccc; \
    .dword 0xbbbbbbbbbbbbbbbb, 0x7777777777777777, 0x6666666666666666, 0x4444444444444444; \
    .dword 0x1111111111111111, 0x2222222222222222, 0x3333333333333333, 0x4444444444444444; \
    .dword 0x56789abc56789abc, 0x0f0f0f0f0f0f0f0f, 0xf0f0f0f0f0f0f0f0, 0x8000000000000000; \
expected: \
    .dword 0x0000000000000000; \
    .dword 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff; \
    .dword 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff; \
    .dword 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff; \
    .dword 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff; \
    .dword 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff; \
    .dword 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff; \
    .dword 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff; \
result:     .space 256   /* 64 x 4 bytes = 256 bytes */; \
tohost:     .word 0; \
fromhost:   .word 0

#endif /* _MARCH_TEST_H */

