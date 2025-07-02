# RISC-V Microarchitectural Tests

This project provides a Makefile to build and run RISC-V assembly tests using the Spike simulator.

## Prerequisites

- `riscv64-unknown-elf-gcc` (RISC-V GCC toolchain)
- `spike` (RISC-V ISA Simulator)

## Makefile Targets

### Build

Compile all tests:

```sh
make all
```

Or compile a specific test:

```sh
make build/add.elf
```

You can change the test by setting the `TEST` variable:

```sh
make TEST=sub build/sub.elf
```

### Run

Run the compiled ELF on Spike:

```sh
make run
```

Run all tests and generate a summary report:

```sh
make run-all
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

- `isa/*.S`           - Assembly test files
- `env/link.ld`       - Linker script
- `env/march_test.h`  - Test header
- `macros/test_macros.h` - Test macros
- `build/`            - Output directory for ELF files and test results

## Viewing Test Results

When you run all tests with:

```sh
make run-all
```

a summary of the results will be printed to the terminal and also saved to `build/test_results.txt`.

To view the latest test results, open the file:

```
build/test_results.txt
```

Example output:

```
[Running] add
add.S **** PASS ***
[Running] sub
sub.S **** FAILED ***

___________________________ SUMMARY ____________________________
PASS    : 1
FAIL    : 1
WARNING : 0
ERROR   : 0

Results saved to: build/test_results.txt
```

If any test fails, `make run-all` will return a non-zero exit code.

See `build/test_results.txt` for the full output and details.
