# Stanford Pascal for FreeBSD 15

This is the Stanford Pascal Compiler ported specifically for **FreeBSD 15 (amd64)**. It is based on Bernd Oppolzer's New Stanford Pascal Compiler and P-code interpreter.

## Building the Interpreter

To build the P-code interpreter (`pcint`), use the provided Makefile in the `bin/` directory:

```bash
cd bin/
make
```

Alternatively, from the root directory:

```bash
make
```

The interpreter will be built with hardened flags (`-Wformat-security`) and optimizations (`-O2`).

## Installation

The project includes a robust installation system. To install the compiler system-wide:

```bash
sudo make install
```

By default, this will install:
- `/usr/local/bin/pcint`: The core interpreter.
- `/usr/local/bin/pcomp`: Wrapper to compile `.pas` files into `.pcode`.
- `/usr/local/bin/prun`: Wrapper to execute `.pcode` files.
- `/usr/local/bin/pfmt`: Wrapper to format/beautify Pascal source.
- `/usr/local/lib/stanford-pascal/`: Precompiled compiler blobs and message files.

You can customize the installation prefix:
```bash
sudo make PREFIX=/opt/pascal install
```

### Local Installation (for current user)
To install only for your user account (into `~/.local/bin` and `~/.local/lib/stanford-pascal`):

```bash
make install-local
```
This is the recommended way if you don't have root access.

## Compilation and Execution

### Fast Compile & Run
The `spascal` script allows you to compile and run a Pascal program in one step:

```bash
spascal myprog.pas
```

### Manual Compiling a Program
Use `pcomp` to compile your Pascal source:

```bash
pcomp myprog.pas
```
This generates `myprog.pcode`.

### Running a Program
Use `prun` to run the compiled P-code:

```bash
prun myprog.pcode
```

## Automated Testing

To run the full suite of included tests and verify your installation, execute:

```bash
./test_runner.sh
```

This will run the programs in `srctest/` and `testpgm/` and report on the status.

## Current Limitations
- This is an interpreted compiler. Native x86 machine code is not yet generated.
- Many legacy tests from the mainframe days may fail due to specific file structure or OS environment requirements.

---
Ported to FreeBSD by Jon2Allen - 2026.
