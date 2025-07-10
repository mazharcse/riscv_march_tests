# Default test file if not specified
TEST ?= context_switch
TEST_FILE := isa/$(notdir $(TEST)).S
INSTALL_PATH =
INSTALL_DIR = $(abspath $(INSTALL_PATH) )

LINKERFILE = env/link.ld
NAME       = $(basename $(notdir $(TEST_FILE)))

#RISCV_INSTALL = ~/usr/riscv
#RISCV_BIN     = $(RISCV_INSTALL)/bin

#GCC     = $(RISCV_BIN)/riscv32-unknown-elf-gcc
#OBJCOPY = $(RISCV_BIN)/riscv32-unknown-elf-objcopy
#OBJDUMP = $(RISCV_BIN)/riscv32-unknown-elf-objdump
GCC     = riscv64-unknown-elf-gcc
OBJCOPY = riscv64-unknown-elf-objcopy
OBJDUMP = riscv64-unknown-elf-objdump
NM      = riscv64-unknown-elf-nm

ELF2SYM = ./elf2sym.py
# ELF2SYM = $(RISCV_CORE_ROOT)/bin/elf2sym.py

# 16b and 32b instructions
GCC_OPT =-nostdlib -nostartfiles -Wl,--no-relax -Wa,-als,-al
#GCC_OPT =-nostdlib -nostartfiles -Wa,-als,-al

GCC_LINK_OPT =-nostdlib -nostartfiles -Wl,--no-relax -Wa,-als,-al

MARCH =-march=rv64gv_zicbom

BUILD_DIR = build
INCLUDES = -Imacros -Ienv

SOURCES := $(wildcard isa/*.S)
NAMES := $(basename $(notdir $(SOURCES)))
OBJS := $(addprefix $(BUILD_DIR)/,$(addsuffix .o,$(NAMES)))
ELFS := $(addprefix $(BUILD_DIR)/,$(addsuffix .elf,$(NAMES)))
HEXS := $(addprefix $(BUILD_DIR)/,$(addsuffix .hex,$(NAMES)))
SYMS := $(addprefix $(BUILD_DIR)/,$(addsuffix .sym,$(NAMES)))
DISS := $(addprefix $(BUILD_DIR)/,$(addsuffix .dis,$(NAMES)))

all: $(HEXS) $(SYMS) $(DISS)

build: $(BUILD_DIR)/$(NAME).hex $(BUILD_DIR)/$(NAME).sym $(BUILD_DIR)/$(NAME).dis

$(BUILD_DIR)/%.o: isa/%.S cpinstr.inc env/march_test.h macros/test_macros.h
	$(GCC) $(INCLUDES) $(MARCH) -Wa,-als,-al -c -o $@ $< >$(BUILD_DIR)/$*.lst

$(BUILD_DIR)/%.elf: $(BUILD_DIR)/%.o $(LINKERFILE)
	$(GCC) $(MARCH) $(GCC_LINK_OPT) -T$(LINKERFILE) -o $@ $<

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf
	$(OBJCOPY) -O verilog $< $@

$(BUILD_DIR)/%.sym: $(BUILD_DIR)/%.elf
	$(NM) $< > $@
#   $(ELF2SYM) $< $@

$(BUILD_DIR)/%.dis: $(BUILD_DIR)/%.elf
	$(OBJDUMP) -M numeric -D --section=.boot --section=.text $< > $@

install: build | $(INSTALL_DIR)
	@echo Installing $(BUILD_DIR)/$(NAME).hex $(BUILD_DIR)/$(NAME).sym $(BUILD_DIR)/$(NAME).dis to $(INSTALL_DIR)
	cp $(BUILD_DIR)/$(NAME).hex $(BUILD_DIR)/$(NAME).sym $(BUILD_DIR)/$(NAME).dis $(INSTALL_DIR)

uninstall:
	@echo Uninstalling $(BUILD_DIR)/$(NAME).hex $(BUILD_DIR)/$(NAME).sym $(BUILD_DIR)/$(NAME).dis from $(INSTALL_DIR)
	@cd $(INSTALL_DIR) && rm -f $(BUILD_DIR)/$(NAME).hex $(BUILD_DIR)/$(NAME).sym $(BUILD_DIR)/$(NAME).dis

$(INSTALL_DIR):
	mkdir $(INSTALL_DIR)

.PHONY: clean all

clean:
	@rm -f $(BUILD_DIR)/* $(BUILD_DIR)/*.lst

SPIKE = spike
SPIKE_FLAGS = -d --isa=RV64gV --varch=vlen:2048,elen:64,slen:2048 -m0x80000000

run: $(BUILD_DIR)/$(NAME).elf
	$(SPIKE) $(SPIKE_FLAGS) $<

