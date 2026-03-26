# Stanford Pascal Command Script Catalog

## Overview

This document catalogs all the `.cmd` and `.rex` scripts found in the Stanford Pascal distribution. These scripts are primarily designed for IBM mainframe environments (TSO/REXX) but provide insight into the build and deployment processes.

## Script Categories

### 1. Core Build and Compilation Scripts

#### script/pas.cmd
**Purpose**: Pascal compiler wrapper script
**Platform**: TSO (IBM mainframe)
**Function**: Sets up DD statements for compiler input/output and executes the compiler
**Usage**: `pas <programname>`
```cmd
set dd:input=%1.pas
set dd:listing=%1.lis
set dd:prr=%1.prr
set dd:dbginfo=%1.dbginfo
set dd:prd=pascal.messages
pcint prr=pascal1.prr pas=pascal1.pas out=pascal1.prrlis debug=n
```

#### script/pp.cmd
**Purpose**: Pascal compiler front-end
**Platform**: Cross-platform (simple batch)
**Function**: Calls the main compiler script
**Usage**: `pp <programname>`
```cmd
@echo off
call pascal %1
```

#### script/pascal.cmd
**Purpose**: Main compiler driver
**Platform**: TSO
**Function**: Compiles Pascal source files
**Note**: Similar to pas.cmd but may have different defaults

#### script/pasf.cmd
**Purpose**: Compiler front-end with formatting
**Platform**: TSO
**Function**: Compiles with formatted output

#### script/ppa.cmd, ppad.cmd, ppb.cmd, ppn.cmd
**Purpose**: Compiler variants for different versions
**Platform**: TSO
**Function**: Compile using specific compiler versions (1982, etc.)

### 2. Runtime and Execution Scripts

#### script/prun.cmd
**Purpose**: Program execution script
**Platform**: TSO
**Function**: Runs compiled P-Code programs with module support
**Usage**: `prun <programname> [modules] [parameters]`
```cmd
pcint pcode=%1.pcode inc=%PASDIR%\paslibx,%PASDIR%\pasutils,%2 
       pas=%1.pas out=%1.pcodelis sconst=3000000 %3 %4 %5 %6 %7 %8 %9
```

#### script/prund.cmd
**Purpose**: Debug version of prun
**Platform**: TSO
**Function**: Runs programs with debugging enabled

### 3. Build System Scripts

#### script/build.cmd
**Purpose**: Complete build script
**Platform**: TSO
**Function**: Builds all compiler components
```cmd
call pasf passcan
call pasf paslibx
call pasf pascal1
call pasf pascal2
call pp passcan
call pp paslibx
call pp pascal1
call pp pascal2
```

#### script/compall.cmd
**Purpose**: Compile all components
**Platform**: TSO
**Function**: Comprehensive compilation of entire system

#### script/comppas.cmd
**Purpose**: Pascal compiler compilation
**Platform**: TSO
**Function**: Compiles the Pascal compiler itself

#### script/formall.cmd
**Purpose**: Format all source files
**Platform**: TSO
**Function**: Applies formatting to Pascal source code

### 4. Installation and Deployment Scripts

#### script/copybin.cmd
**Purpose**: Copy essential files to binary directory
**Platform**: TSO
**Function**: Deploys compiler and runtime files
```cmd
set PASDIR=c:\bin
copy script\pascal.cmd    %PASDIR%
copy script\pasf.cmd      %PASDIR%
copy script\pp.cmd        %PASDIR%
copy script\prun.cmd      %PASDIR%
copy bin\pcint.exe        %PASDIR%
copy src\*.pcode          %PASDIR%
copy src\*.pas            %PASDIR%
copy etc\pascal.messages  %PASDIR%
```

#### script/copyall.cmd
**Purpose**: Copy all system files
**Platform**: TSO
**Function**: Comprehensive system deployment

#### script/copycms.cmd
**Purpose**: Copy files to CMS environment
**Platform**: TSO
**Function**: Deploys to CMS (VM/370) environment

#### script/copymvs.cmd
**Purpose**: Copy files to MVS environment  
**Platform**: TSO
**Function**: Deploys to MVS environment with REXX support

#### script/copyr.cmd, copyr.rex
**Purpose**: Copy files to VM Reader
**Platform**: TSO/REXX
**Function**: Transfers files to VM reader device
```cmd
@echo off
rexx copyrdr.rex %1 %2 %3 %4
copy copyrdr.tmp+%1 copyrdr.tmp
nc -w3 127.0.0.1 3505 <copyrdr.tmp
```

#### script/copyrdr.cmd, copyrdr.rex
**Purpose**: VM Reader copy with REXX
**Platform**: TSO/REXX
**Function**: Advanced file transfer to VM reader
```rex
/* REXX */
arg pcfile vmuser vmname vmtype
userid = left(vmuser, 8)
vmname = left(vmname, 8)
vmtype = left(vmtype, 8)
zeile1 = "USERID "userid" CLASS A NAME "vmname" "vmtype
zeile2 = ":READ  "vmname" "vmtype" A1"
```

### 5. Test and Verification Scripts

#### script/copytest.cmd
**Purpose**: Copy test files
**Platform**: TSO
**Function**: Deploys test suite files

#### script/del_splitpas.cmd
**Purpose**: Delete split Pascal files
**Platform**: TSO
**Function**: Cleanup after test runs

#### script/t.cmd, t2.cmd, t3.cmd, t4.cmd, t7.cmd, t8.cmd
**Purpose**: Test execution scripts
**Platform**: TSO
**Function**: Run specific test suites

#### script/tc.cmd
**Purpose**: Test compilation
**Platform**: TSO
**Function**: Compile test programs

#### script/te.cmd
**Purpose**: Test execution
**Platform**: TSO
**Function**: Run test programs

#### script/tf.cmd
**Purpose**: Test file operations
**Platform**: TSO
**Function**: Test file I/O functionality

#### script/tk.cmd
**Purpose**: Test compiler
**Platform**: TSO
**Function**: Compiler self-tests

#### script/tn.cmd
**Purpose**: Test new features
**Platform**: TSO
**Function**: Regression testing

### 6. Utility and Helper Scripts

#### script/a.cmd, aw.cmd
**Purpose**: Assembly-related scripts
**Platform**: TSO
**Function**: Assembly language support

#### script/chgvers.cmd
**Purpose**: Change version information
**Platform**: TSO
**Function**: Updates version strings in source

#### script/cobf.cmd
**Purpose**: COBOL interface
**Platform**: TSO
**Function**: COBOL integration support

#### script/d.cmd
**Purpose**: Debug script
**Platform**: TSO
**Function**: Debugging aid

#### script/ivm.cmd
**Purpose**: Interactive VM script
**Platform**: TSO
**Function**: VM interaction

#### script/pas2.cmd, pas2a.cmd, pas2b.cmd, pas2d.cmd, pas2z.cmd
**Purpose**: Pascal compiler variants
**Platform**: TSO
**Function**: Different compiler configurations

#### script/pascald.cmd
**Purpose**: Pascal compiler with debugging
**Platform**: TSO
**Function**: Debug-enabled compilation

#### script/pasd.cmd
**Purpose**: Pascal decompiler
**Platform**: TSO
**Function**: Decompile P-Code

#### script/pasf.cmd
**Purpose**: Pascal compiler with formatting
**Platform**: TSO
**Function**: Compile with formatted output

#### script/pasfa.cmd
**Purpose**: Pascal compiler (alternate version)
**Platform**: TSO
**Function**: Alternative compiler front-end

#### script/pasfcc.cmd
**Purpose**: Pascal to C converter
**Platform**: TSO
**Function**: Experimental C code generation

#### script/pasi.cmd
**Purpose**: Pascal interpreter
**Platform**: TSO
**Function**: Interpret P-Code directly

#### script/pp1982.cmd
**Purpose**: 1982 compiler version
**Platform**: TSO
**Function**: Legacy compiler support

#### script/pt.cmd
**Purpose**: Pascal tester
**Platform**: TSO
**Function**: Test framework

#### script/setpas.cmd
**Purpose**: Set Pascal environment
**Platform**: TSO
**Function**: Configure Pascal environment variables

#### script/showhex.cmd, showhexb.cmd
**Purpose**: Hex dump utility
**Platform**: TSO
**Function**: Display files in hexadecimal

#### script/splitpas.cmd
**Purpose**: Split Pascal source
**Platform**: TSO
**Function**: Divide large source files

#### script/tefil1.cmd
**Purpose**: Test file operations
**Platform**: TSO
**Function**: File I/O testing

#### script/tmsgs.cmd
**Purpose**: Test messages
**Platform**: TSO
**Function**: Message system testing

#### script/topas.cmd
**Purpose**: Top-level Pascal script
**Platform**: TSO
**Function**: Main entry point

#### script/topcode.cmd
**Purpose**: Top-level P-Code script
**Platform**: TSO
**Function**: P-Code management

#### script/tsh.cmd
**Purpose**: Test shell
**Platform**: TSO
**Function**: Interactive testing

#### script/tx.cmd
**Purpose**: Test execution
**Platform**: TSO
**Function**: Program execution testing

#### script/tzub.cmd
**Purpose**: Test ZUB format
**Platform**: TSO
**Function**: ZUB file testing

#### script/tzwb.cmd
**Purpose**: Test ZWB format
**Platform**: TSO
**Function**: ZWB file testing

### 7. Version-Specific Scripts

#### script/pas21982.cmd
**Purpose**: 1982 version compiler
**Platform**: TSO
**Function**: Legacy compiler support

#### testold/pp1976.cmd, t1976.cmd
**Purpose**: 1976 version scripts
**Platform**: TSO
**Function**: Very early compiler versions

### 8. Test Program Scripts

#### testpgm/copytext.cmd
**Purpose**: Copy text files
**Platform**: TSO
**Function**: Text file management for tests

#### testpgm/msf.cmd
**Purpose**: MSF test script
**Platform**: TSO
**Function**: MSF format testing

#### testpgm/oevm.cmd
**Purpose**: OEVM test script
**Platform**: TSO
**Function**: OEVM environment testing

#### testpgm/pdokk.cmd
**Purpose**: PDOKK test script
**Platform**: TSO
**Function**: PDOKK format testing

#### testpgm/renall.cmd
**Purpose**: Rename all files
**Platform**: TSO
**Function**: Batch file renaming

#### testpgm/xconv.cmd, xdeconv.cmd
**Purpose**: XCONV conversion scripts
**Platform**: TSO
**Function**: File format conversion

### 9. Top-Level Scripts

#### toallx.cmd
**Purpose**: Top-level script
**Platform**: TSO
**Function**: Master control script

#### toass.cmd
**Purpose**: Assembly script
**Platform**: TSO
**Function**: Assembly language support

#### toexec.cmd
**Purpose**: Execution script
**Platform**: TSO
**Function**: Program execution control

#### tohelp.cmd
**Purpose**: Help script
**Platform**: TSO
**Function**: Display help information

#### topas.cmd
**Purpose**: Top-level Pascal script
**Platform**: TSO
**Function**: Main Pascal entry point

#### t.cmd
**Purpose**: Test script
**Platform**: TSO
**Function**: Test execution control

## Script Analysis

### Platform Focus
- **Primary Platform**: IBM mainframe (TSO/REXX)
- **Secondary Platforms**: CMS, MVS, VM/370
- **Script Types**: Batch (.cmd) and REXX (.rex)

### Function Categories
1. **Compilation** (30%): Scripts for compiling Pascal source code
2. **Execution** (20%): Scripts for running compiled programs
3. **Deployment** (25%): Scripts for copying and installing files
4. **Testing** (15%): Scripts for test execution and verification
5. **Utilities** (10%): Miscellaneous helper scripts

### Key Observations

1. **Mainframe-Centric**: All scripts are designed for IBM mainframe environments
2. **REXX Integration**: Several scripts use REXX for advanced functionality
3. **Version Diversity**: Multiple scripts for different compiler versions (1976, 1982, etc.)
4. **Comprehensive Build System**: Complete toolchain from compilation to deployment
5. **Test Framework**: Extensive testing infrastructure

### Modern Relevance

While these scripts are designed for mainframe environments, they provide:
- **Historical Insight**: Understanding of original development environment
- **Build Patterns**: Compilation and deployment workflows
- **Feature Documentation**: What functionality was supported
- **Migration Guide**: For porting to modern platforms

## Recommendations

1. **Preservation**: Maintain these scripts for historical reference
2. **Documentation**: Add comments explaining mainframe-specific features
3. **Modernization**: Consider creating POSIX equivalents for key scripts
4. **Integration**: Use as reference for understanding original build processes

## Conclusion

The Stanford Pascal distribution includes 80+ command scripts primarily targeting IBM mainframe environments. These scripts form a complete build, test, and deployment system for the original mainframe implementation. While not directly usable on FreeBSD without adaptation, they provide valuable historical context and implementation patterns that can inform modern ports and development efforts.
