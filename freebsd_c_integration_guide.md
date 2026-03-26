# Stanford Pascal C Integration Guide for FreeBSD

## Overview

Stanford Pascal provides limited support for external language integration, primarily focused on FORTRAN and ASSEMBLER on mainframe systems. However, on FreeBSD and PC platforms, the current implementation has significant limitations for C integration.

## Current State of C Integration

### Limitations

1. **No Direct C Calling**: The P-Code interpreter (`pcint`) cannot directly call C functions on FreeBSD/PC platforms
2. **Mainframe Focus**: External language support is designed for IBM mainframe (FORTRAN/ASSEMBLER)
3. **Compiler Restriction**: The compiler comment explicitly states "cannot call external C objects at the moment"

### Supported External Languages

Based on compiler source analysis:
- **FORTRAN**: Supported on mainframe systems
- **ASSEMBLER**: Supported on mainframe systems  
- **Pascal**: Full support for Pascal external modules
- **C**: Not currently supported on FreeBSD/PC platforms

## Alternative Integration Approaches

### 1. External Module Approach (Recommended)

Create Pascal wrapper modules that interface with C code through separate processes or files.

#### Example: C Function Wrapper

**C Code (`mathfuncs.c`):**
```c
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <function> <value>\n", argv[0]);
        return 1;
    }
    
    double value = atof(argv[2]);
    double result;
    
    if (strcmp(argv[1], "sin") == 0) {
        result = sin(value);
    } else if (strcmp(argv[1], "cos") == 0) {
        result = cos(value);
    } else if (strcmp(argv[1], "sqrt") == 0) {
        result = sqrt(value);
    } else {
        fprintf(stderr, "Unknown function: %s\n", argv[1]);
        return 1;
    }
    
    printf("%.15g\n", result);
    return 0;
}
```

**Pascal Wrapper Module (`cmath.pas`):**
```pascal
module CMATH;

function CSIN(X: REAL): REAL; EXTERNAL;
function CCOS(X: REAL): REAL; EXTERNAL;
function CSQRT(X: REAL): REAL; EXTERNAL;

(* Implementation using external process calls *)
function RUNCOMMAND(COMMAND: STRING): REAL;
var
  F: TEXT;
  RESULT: REAL;
  CMD: STRING;
begin
  (* This would need to be implemented using system calls *)
  (* For now, this is a placeholder showing the concept *)
  RUNCOMMAND := 0.0;
end;

begin end.
```

### 2. File-Based Communication

Use temporary files for data exchange between Pascal and C programs.

#### Example Workflow:

1. **Pascal writes input data to file**
2. **Calls C program via SYSTEM**
3. **C program processes data and writes results**
4. **Pascal reads results from file**

**Pascal Code:**
```pascal
procedure CALL_C_FUNCTION(INPUT: REAL; var OUTPUT: REAL);
var
  F: TEXT;
  CMD: STRING;
begin
  (* Write input to temporary file *)
  REWRITE(F, 'temp_input.dat');
  WRITELN(F, INPUT:20:15);
  CLOSE(F);
  
  (* Call C program *)
  CMD := 'mathfuncs sin < temp_input.dat > temp_output.dat';
  SYSTEM(CMD);
  
  (* Read output from temporary file *)
  RESET(F, 'temp_output.dat');
  READLN(F, OUTPUT);
  CLOSE(F);
end;
```

### 3. Shared Memory Approach

For more advanced integration, use memory-mapped files or shared memory.

**Concept:**
```pascal
(* This would require custom CSP implementations *)
function SHARED_MEM_CALL(FUNC_NAME: STRING; PARAM: REAL): REAL;
  EXTERNAL;
```

## Current Working Solutions

### 1. Pascal External Modules

The most reliable approach is to use Pascal external modules:

**Module Definition:**
```pascal
module MATHLIB;

function MY_SIN(X: REAL): REAL;
begin
  (* Pascal implementation of sine function *)
  MY_SIN := X - (X*X*X)/6 + (X*X*X*X*X)/120; (* Taylor series approximation *)
end;

function MY_COS(X: REAL): REAL;
begin
  (* Pascal implementation of cosine function *)
  MY_COS := 1 - (X*X)/2 + (X*X*X*X)/24; (* Taylor series approximation *)
end;

begin end.
```

**Main Program:**
```pascal
program MAIN;

function MY_SIN(X: REAL): REAL; EXTERNAL;
function MY_COS(X: REAL): REAL; EXTERNAL;

var
  angle, sine_val, cosine_val: REAL;

begin
  angle := 0.5;
  sine_val := MY_SIN(angle);
  cosine_val := MY_COS(angle);
  
  WRITELN('SIN(', angle:5:2, ') = ', sine_val:10:6);
  WRITELN('COS(', angle:5:2, ') = ', cosine_val:10:6);
end.
```

### 2. Using SYSTEM Calls

Call external programs from Pascal:

```pascal
program EXTERNAL_CALL;

var
  result: INTEGER;

begin
  WRITELN('Calling external program...');
  
  (* Call external program *)
  result := SYSTEM('ls -la');
  
  WRITELN('External program returned: ', result);
end.
```

## Future Possibilities

### Potential Enhancement Areas

1. **CSP Extension**: Add C calling convention support to Call Standard Procedures
2. **Dynamic Linking**: Implement `dlopen()`/`dlsym()` support in interpreter
3. **Foreign Function Interface**: Develop FFI layer for multiple languages
4. **Compiler Enhancement**: Add C external procedure declaration syntax

### Required Changes for C Support

1. **Interpreter Modifications** (`pcint.c`):
   - Add C calling convention support
   - Implement dynamic library loading
   - Add type conversion between Pascal and C types

2. **Compiler Enhancements** (`pascal1.pas`):
   - Add C external procedure syntax
   - Generate appropriate call sequences
   - Handle C type mappings

3. **New CSP Functions**:
   - `LOAD_LIBRARY(NAME: STRING): INTEGER`
   - `GET_PROC_ADDRESS(LIB: INTEGER; NAME: STRING): POINTER`
   - `CALL_C_FUNCTION(ADDR: POINTER; PARAMS: ARRAY OF BYTE): INTEGER`

## Workaround: Mixed Language Development

### Development Process

1. **Identify C Functions**: Determine which functions need C implementation
2. **Create C Library**: Develop C functions as standalone programs
3. **Design Pascal Interface**: Create Pascal wrapper procedures
4. **Implement Communication**: Use files, pipes, or shared memory
5. **Test Integration**: Verify data exchange and error handling

### Example: Scientific Computing

**C Implementation (`matrix_ops.c`):**
```c
#include <stdio.h>
#include <stdlib.h>

void matrix_multiply() {
    // Read matrix dimensions and data from stdin
    // Perform matrix multiplication
    // Write results to stdout
}

int main() {
    matrix_multiply();
    return 0;
}
```

**Pascal Interface (`matrix.pas`):**
```pascal
module MATRIX;

procedure MATRIX_MULTIPLY(A, B: ARRAY OF ARRAY OF REAL; 
                          var C: ARRAY OF ARRAY OF REAL);
(* Implementation would use external process calls *)

begin end.
```

## Recommendations for FreeBSD

### Current Best Practices

1. **Use Pascal for Core Logic**: Maximize use of Pascal for main program logic
2. **Isolate C Requirements**: Identify specific functions requiring C implementation
3. **Process-Based Integration**: Use separate processes with file/pipes communication
4. **Performance Considerations**: Minimize process creation overhead
5. **Error Handling**: Implement robust error checking for external calls

### Build System Integration

**Makefile Example:**
```makefile
# Combined Pascal/C build system

PASCAL = pascal
PCINT = pcint
CC = cc

all: program.run

# Build C components
mathfuncs: mathfuncs.c
	$(CC) -o $@ $<

# Build Pascal components  
mathlib.pcode: mathlib.pas
	$(PASCAL) pas=$< pcode=$@

main.pcode: main.pas
	$(PASCAL) pas=$< pcode=$@

# Run with all components
program.run: main.pcode mathlib.pcode mathfuncs
	$(PCINT) pcode=main.pcode inc=mathlib.pcode

clean:
	rm -f *.pcode *.run mathfuncs
```

## Conclusion

While Stanford Pascal on FreeBSD does not currently support direct C function calls, several practical workarounds exist:

1. **External Modules**: Use Pascal modules for code organization
2. **Process Communication**: Call C programs via SYSTEM and exchange data through files
3. **Wrapper Libraries**: Create Pascal wrappers around C functionality
4. **Hybrid Development**: Combine strengths of both languages in separate components

For most applications, the external module system provides sufficient modularity without requiring C integration. When C functionality is essential, process-based communication offers a reliable cross-platform solution.

**Future Enhancement Potential**: The compiler architecture could be extended to support C integration, but this would require significant modifications to both the compiler and interpreter.
