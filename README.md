# RISC-V Microarchitectural Tests

This project provides a Makefile to build and run RISC-V assembly tests using the Spike simulator.

## Prerequisites

- `riscv64-unknown-elf-gcc` (RISC-V GCC toolchain)
- `spike` (RISC-V ISA Simulator)

## Makefile Targets

### Build

Compile the test (default is `add.S`):

```sh
make
```

or explicitly:

```sh
make add.elf
```

You can change the test by setting the `TEST` variable:

```sh
make TEST=your_test_name
```

### Run

Run the compiled ELF on Spike:

```sh
make run
```

You can enable Spike debug mode by setting `DEBUG=1`:

```sh
make run DEBUG=1
```

### Clean

Remove generated ELF files:

```sh
make clean
```

## Configuration

- `MARCH`: Set the RISC-V architecture (default: `rv64g`)
- `TEST`:  Set the test file prefix (default: `add`)
- `DEBUG`: Set to `1` to enable Spike debug mode

Example:

```sh
make run TEST=sub MARCH=rv32i DEBUG=1
```

## File Structure

- `*.S`           - Assembly test files
- `link.ld`       - Linker script
- `march_test.h`  - Test header
- `test_macros.h` - Test macros
