# Makefile for RISC-V March Tests

SHELL := /bin/bash

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
# Default Target
# -------------------------------
.DEFAULT_GOAL := run

# -------------------------------
# Build ELF Target
# -------------------------------
$(TEST).elf: $(TEST).S link.ld march_test.h test_macros.h
	@echo "[Compiling] $< -> $@"
	@$(CC) $(CFLAGS) $< -o $@ -T link.ld

# -------------------------------
# Run on Spike
# -------------------------------
.PHONY: run
run: $(TEST).elf
	@echo "[Running on Spike] $(TEST).elf"
	@spike -l $(SPIKE_FLAGS) -m0x80000000:0x800000 $(TEST).elf

# -------------------------------
# Clean
# -------------------------------
.PHONY: clean
clean:
	@echo "[Cleaning]"
	@$(RM) *.elf




