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
CFLAGS  := -march=$(MARCH) -nostdlib -nostartfiles -Ienv -Imacros

# Spike flags
SPIKE_FLAGS :=
ifeq ($(DEBUG), 1)
SPIKE_FLAGS += -d
endif

# Output directory
OUTDIR := build

# -------------------------------
# Test List
# -------------------------------
TESTS := add sub

# -------------------------------
# Default Target
# -------------------------------
.DEFAULT_GOAL := run

# -------------------------------
# Ensure build/ directory exists
# -------------------------------
$(OUTDIR):
	@mkdir -p $(OUTDIR)

# -------------------------------
# Pattern Rule for Building ELFs
# -------------------------------
$(OUTDIR)/%.elf: isa/%.S env/link.ld env/march_test.h macros/test_macros.h | $(OUTDIR)
	@echo "[Compiling] $< -> $@"
	$(CC) $(CFLAGS) $< -o $@ -T env/link.ld

# -------------------------------
# Build All ELFs
# -------------------------------
all: $(TESTS:%=$(OUTDIR)/%.elf)

# -------------------------------
# Run Single Test on Spike
# -------------------------------
run: $(OUTDIR)/$(TEST).elf
	@echo "[Running on Spike] $(OUTDIR)/$(TEST).elf"
	spike -l $(SPIKE_FLAGS) -m0x80000000:0x800000 $(OUTDIR)/$(TEST).elf

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
	$(RM) $(OUTDIR)/*.elf




