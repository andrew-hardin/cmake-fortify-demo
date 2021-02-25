# CMake + Fortify
This project integrates the Fortify C/C++ source analyzer into a CMake build system.
For the uninitiated, here's the general idea:

```text
# Normal:
source.cpp -> compiler -> source.o

# When using Fortify:
source.cpp -> fortify -> compiler -> source.o
```

Fortify acts as a shim between your source code and the compiler.
This project implements that shim by creating a custom toolchain
that's passed to CMake.

## Getting Started
```bash

# Clone and configure the project.
mkdir build
cd build
cmake .. -DWITH_FORTIFY=ON -DFORTIFY_PROJECT_ID=sample-cpp

# Clean the Fortify project.
sourceanalyzer -b sample-cpp -clean

# Build.
make

# Generate the audit project.
sourceanalyzer -b sample-cpp -scan -f sample-cpp.fpr
ls *.fpr

# View the project in the audit workbench.
auditworkbench sample-cpp.fpr

# Question the choices that brought you to this point in
# your career.
```

## References
- [Question on StackOverflow](https://stackoverflow.com/questions/36428360/use-fortify-sourceanalyzer-with-cmake)