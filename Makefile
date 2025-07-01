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
	@results_file="$(OUTDIR)/test_results.txt"; \
	pass_count=0; fail_count=0; warn_count=0; error_count=0; \
	echo "RISC-V March Test Results" > $$results_file; \
	echo "=========================" >> $$results_file; \
	echo "" >> $$results_file; \
	failed_tests=""; \
	for test in $(TESTS); do \
		echo "[Running] $$test"; \
		if $(MAKE) TEST=$$test run >/dev/null 2>&1; then \
			result="$$test.S **** PASSED ***"; \
			echo "$$result"; \
			echo "$$result" >> $$results_file; \
			pass_count=$$((pass_count + 1)); \
		else \
			result="$$test.S **** FAILED ***"; \
			echo "$$result"; \
			echo "$$result" >> $$results_file; \
			fail_count=$$((fail_count + 1)); \
			failed_tests="$$failed_tests $$test"; \
		fi; \
	done; \
	echo ""; \
	echo "" >> $$results_file; \
	summary_line="___________________________ SUMMARY ____________________________"; \
	echo "$$summary_line"; \
	echo "$$summary_line" >> $$results_file; \
	printf "PASS    : %d\n" $$pass_count; \
	printf "PASS    : %d\n" $$pass_count >> $$results_file; \
	printf "FAIL    : %d\n" $$fail_count; \
	printf "FAIL    : %d\n" $$fail_count >> $$results_file; \
	printf "WARNING : %d\n" $$warn_count; \
	printf "WARNING : %d\n" $$warn_count >> $$results_file; \
	printf "ERROR   : %d\n" $$error_count; \
	printf "ERROR   : %d\n" $$error_count >> $$results_file; \
	echo ""; \
	echo "" >> $$results_file; \
	echo "Results saved to: $$results_file"; \
	if [ $$fail_count -gt 0 ]; then \
		exit 1; \
	fi

# -------------------------------
# Clean
# -------------------------------
clean:
	@echo "[Cleaning]"
	$(RM) $(OUTDIR)/*.elf
