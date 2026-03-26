# Stanford Pascal Multi-Module Programming on FreeBSD

## Overview

Stanford Pascal supports multi-module programming through a combination of separate compilation and P-Code module loading. This guide explains how to structure and compile multi-module programs on FreeBSD.

## Module Types

### 1. Main Programs
- Use `PROGRAM` keyword
- Contain executable code with a main block
- Can import and use external modules

### 2. External Modules
- Use `MODULE` keyword (Stanford Pascal extension)
- Collection of external procedures without a main program
- Must have empty main block: `begin end.`
- Can be loaded by multiple programs

## Module Structure

### Main Program Example (`main.pas`)
```pascal
program MAINPROG (INPUT, OUTPUT);

// Import external module procedures
procedure EXTPROC1; EXTERNAL;
function EXTFUNC2(X: INTEGER): REAL; EXTERNAL;

var
  result: REAL;
  i: INTEGER;

begin
  WRITELN('Main program starting');
  
  // Call external procedure
  EXTPROC1;
  
  // Call external function
  i := 42;
  result := EXTFUNC2(i);
  WRITELN('Function result: ', result);
  
  WRITELN('Main program ending');
end.
```

### External Module Example (`mymodule.pas`)
```pascal
module MYMODULE;

procedure EXTPROC1;
begin
  WRITELN('External procedure called');
end;

function EXTFUNC2(X: INTEGER): REAL;
begin
  EXTFUNC2 := X * 3.14;
end;

// Required empty main block for modules
begin end.
```

## Compilation Process

### Step 1: Compile External Modules
```bash
# Compile module to P-Code
pascal pas=mymodule.pas pcode=mymodule.pcode
```

### Step 2: Compile Main Program
```bash
# Compile main program to P-Code
pascal pas=main.pas pcode=main.pcode
```

### Step 3: Run with Module Loading
```bash
# Run main program with module
pcint pcode=main.pcode inc=mymodule.pcode
```

## P-Code Module Loading Mechanism

### How It Works
1. **`%INCLUDE` Directive**: The compiler generates `%INCLUDE` directives in P-Code
2. **Interpreter Loading**: The P-Code interpreter (`pcint`) loads additional modules via the `inc=` parameter
3. **Symbol Resolution**: External procedure/function calls are resolved at runtime

### P-Code Structure
When compiling with multiple modules, the compiler generates:
- Main P-Code file with `%INCLUDE` directives
- Separate P-Code files for each module
- Cross-reference tables for external symbols

Example P-Code with include:
```
%INCLUDE mymodule.pcode
```

## FreeBSD-Specific Considerations

### File Paths
- Use absolute or relative paths for module files
- Ensure read permissions on all P-Code files
- Recommended to use same directory or standard library paths

### Makefile Example
```makefile
# Stanford Pascal Multi-Module Makefile for FreeBSD

PASCAL = pascal
PCINT = pcint

all: main.run

# Compile external module
mymodule.pcode: mymodule.pas
	$(PASCAL) pas=$< pcode=$@

# Compile main program
main.pcode: main.pas
	$(PASCAL) pas=$< pcode=$@

# Run program with module
main.run: main.pcode mymodule.pcode
	$(PCINT) pcode=main.pcode inc=mymodule.pcode

clean:
	rm -f *.pcode *.run
```

## Advanced Multi-Module Features

### Multiple Module Loading
```bash
pcint pcode=main.pcode inc=module1.pcode,module2.pcode,module3.pcode
```

### Module Dependencies
- Modules can depend on other modules
- Load order matters - dependencies must be loaded first
- Use comma-separated list in correct dependency order

### Separate Compilation Workflow
1. **Develop modules independently**
2. **Test modules with test harnesses**
3. **Compile modules to P-Code**
4. **Integrate with main program**
5. **Run with module loading**

## Debugging Multi-Module Programs

### Common Issues
1. **Symbol not found**: Module not loaded or wrong order
2. **Version mismatch**: Recompile all modules
3. **File not found**: Check paths and permissions

### Debugging Tips
- Use `-v` flag if available for verbose loading
- Check P-Code files contain expected symbols
- Verify module interfaces match

## Example: Multi-Module Program Structure

```
project/
├── main.pas                # Main program
├── mathmodule.pas          # Math functions module
├── iomodule.pas            # I/O utilities module
├── Makefile                # Build configuration
├── main.pcode              # Compiled main program
├── mathmodule.pcode        # Compiled math module
└── iomodule.pcode          # Compiled I/O module
```

## Stanford Pascal Extensions for Modules

### MODULE Keyword
```pascal
module MODULENAME;
// Procedures and functions
begin end.  // Required empty main block
```

### EXTERNAL Declaration
```pascal
procedure PROCNAME; EXTERNAL;
function FUNCNAME(PARAMS): RETURNTYPE; EXTERNAL;
```

### External Language Support
```pascal
procedure FORTRANPROC; EXTERNAL FORTRAN;
procedure ASMPROC; EXTERNAL ASSEMBLER 'ENTRYPOINT';
```

## Performance Considerations

1. **Module Loading Overhead**: Minimal - occurs once at startup
2. **Memory Usage**: All modules loaded into same address space
3. **Execution Speed**: No runtime penalty for external calls
4. **Code Reuse**: Modules can be shared across programs

## Best Practices

1. **Module Design**: Keep modules focused and cohesive
2. **Interface Stability**: Maintain stable external interfaces
3. **Documentation**: Document module dependencies and usage
4. **Versioning**: Use consistent versioning for related modules
5. **Testing**: Test modules independently before integration

## Troubleshooting

### Error: "External not found"
- **Cause**: Module not loaded or wrong name
- **Solution**: Check `inc=` parameter and module filename

### Error: "Symbol mismatch"
- **Cause**: Module interface changed but main program not recompiled
- **Solution**: Recompile all affected programs

### Error: "File not found"
- **Cause**: Module file missing or wrong path
- **Solution**: Verify file exists and path is correct

## Conclusion

Stanford Pascal on FreeBSD provides robust multi-module support through:
- Separate compilation of modules
- Runtime module loading via P-Code interpreter
- External procedure/function declarations
- Flexible module dependency management

This enables large-scale Pascal program development with proper code organization and reuse.
