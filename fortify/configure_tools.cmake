if(CMAKE_TOOLCHAIN_FILE)
    # Our job is done if the toolchain file is already set.
    return()
endif()
message(STATUS "Configuring for Fortify...")

# Find the source analyzer.
find_program(FORTIFY_SOURCE_ANALYZER sourceanalyzer REQUIRED)
message(STATUS "Found sourceanalyzer: ${FORTIFY_SOURCE_ANALYZER}")

# Find the CXX and CC compilers that CMake would use if Fortify
# wasn't part of the build system. This hijacks a piece of CMake
# that's normally called when you execute the project() command.
set(CMAKE_PLATFORM_INFO_DIR "${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/fortify/native")
file(MAKE_DIRECTORY ${CMAKE_PLATFORM_INFO_DIR})
include(${CMAKE_ROOT}/Modules/CMakeDetermineCCompiler.cmake)
include(${CMAKE_ROOT}/Modules/CMakeDetermineCXXCompiler.cmake)
unset(CMAKE_PLATFORM_INFO_DIR)

# Setup the three programs that'll need to be wrapped by Fortify.
set(FORTIFY_AR ${CMAKE_AR})
set(FORTIFY_C_COMPILER ${CMAKE_C_COMPILER})
set(FORTIFY_CXX_COMPILER ${CMAKE_CXX_COMPILER})

# Verify that we found each of them.
if(NOT FORTIFY_C_COMPILER)
    message(FATAL_ERROR "Failed to find CC compiler for Fortify.")
endif()
if(NOT FORTIFY_CXX_COMPILER)
    message(FATAL_ERROR "Failed to find CXX compiler for Fortify.")
endif()
if(NOT FORTIFY_AR)
    message(FATAL_ERROR "Failed to find ar for Fortify.")
endif()

# Configure the toolchain options based on the source analyzer
# path and the commands listed above.
set(OUT "${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/fortify/shim")
set(FORTIFY_C_WRAPPER ${OUT}/cc)
set(FORTIFY_CXX_WRAPPER ${OUT}/cxx)
set(FORTIFY_AR_WRAPPER ${OUT}/ar)
if(NOT EXISTS ${OUT})
    file(MAKE_DIRECTORY ${OUT})
    set(IN "${CMAKE_CURRENT_LIST_DIR}")
    configure_file(${IN}/ar.in ${FORTIFY_AR_WRAPPER} @ONLY)
    configure_file(${IN}/cc.in ${FORTIFY_C_WRAPPER} @ONLY)
    configure_file(${IN}/cxx.in ${FORTIFY_CXX_WRAPPER} @ONLY)
    configure_file(${IN}/toolchain.cmake.in ${OUT}/toolchain.cmake @ONLY)
endif()

# Clean up variables set by the CMake includes.
unset(CMAKE_C_COMPILER)
unset(CMAKE_CXX_COMPILER)
unset(CMAKE_AR)
unset(CMAKE_RANLIB)
unset(_CMAKE_TOOLCHAIN_PREFIX)

# This is the critical instruction where we tell CMake to use the
# custom toolchain that'll point to the Fortify wrapped tools.
set(CMAKE_TOOLCHAIN_FILE ${OUT}/toolchain.cmake)
message(STATUS "Configuring for Fortify... done.")