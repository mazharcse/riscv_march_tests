# Makefile for RISC-V March Tests

SHELL := /bin/bash

# -------------------------------
# Phony Targets
# -------------------------------
.PHONY: all run run-all clean

# -------------------------------
# Configurable Variables
# -------------------------------
MARCH   ?= rv64g
DEBUG   ?= 0
TEST    ?= add

# -------------------------------
# Toolchain and Flags
# -------------------------------
CC      := riscv64-unknown-elf-gcc
CFLAGS  := -march=$(MARCH) -nostdlib -nostartfiles -I.

# Spike flags
SPIKE_FLAGS :=
ifeq ($(DEBUG), 1)
SPIKE_FLAGS += -d
endif

# -------------------------------
# Test List
# -------------------------------
TESTS := add sub

# -------------------------------
# Default Target
# -------------------------------
.DEFAULT_GOAL := run

# -------------------------------
# Pattern Rule for Building ELFs
# -------------------------------
%.elf: %.S link.ld march_test.h test_macros.h
	@echo "[Compiling] $< -> $@"
	@$(CC) $(CFLAGS) $< -o $@ -T link.ld

# -------------------------------
# Build All ELFs
# -------------------------------
all: $(TESTS:%=%.elf)

# -------------------------------
# Run Single Test on Spike
# -------------------------------
run: $(TEST).elf
	@echo "[Running on Spike] $(TEST).elf"
	@spike -l $(SPIKE_FLAGS) -m0x80000000:0x800000 $(TEST).elf

# -------------------------------
# Run All Tests on Spike
# -------------------------------
run-all: all
	@for test in $(TESTS); do \
		$(MAKE) TEST=$$test run || exit 1; \
	done

# -------------------------------
# Clean
# -------------------------------
clean:
	@echo "[Cleaning]"
	@$(RM) *.elf




