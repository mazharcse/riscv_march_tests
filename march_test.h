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

#endif /* _MARCH_TEST_H */
