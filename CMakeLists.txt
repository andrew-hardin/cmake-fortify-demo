# No idea what the true minimum is.
cmake_minimum_required(VERSION 3.0)

# Fortify must be configured prior to project() because it sets compilers.
option(WITH_FORTIFY "Building with Fortify?" OFF)
if(WITH_FORTIFY)
    set(FORTIFY_PROJECT_ID "sample-cpp" CACHE STRING "Project ID used by Fortify.")
    include(fortify/configure_tools.cmake)
endif()

# Setup the project with a single executable.
project(fortify-sample)
add_executable(sample sample.cpp)