cmake_minimum_required(VERSION 3.25)
project(hpc_project VERSION 1.0.0 LANGUAGES C CXX)

# === OPTIONS ===
option(HPC_BUILD_CPU      "Build CPU backend"     ON)
option(HPC_BUILD_CUDA     "Build CUDA backend"    OFF)
option(HPC_BUILD_ROCM     "Build ROCm backend"    OFF)
option(HPC_BUILD_METAL    "Build Metal backend"   OFF)
option(HPC_BUILD_VULKAN   "Build Vulkan backend"  OFF)
option(HPC_BUILD_HYBRID   "Build hybrid scheduler" OFF)
option(HPC_BUILD_TESTS    "Build tests"           ON)
option(HPC_BUILD_BENCH    "Build benchmarks"      ON)
option(HPC_ENABLE_ASAN    "Enable AddressSanitizer" OFF)
option(HPC_ENABLE_LTO     "Enable Link-Time Optimization" ON)

# === GLOBAL SETTINGS ===
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON)          # For GNU inline asm, builtins

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# === MODULE PATH ===
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules")

# === COMPILER FLAGS ===
include(cmake/compiler_options.cmake)
include(cmake/cpu_features.cmake)

# === SANITIZERS ===
if(HPC_ENABLE_ASAN)
    include(cmake/sanitizers.cmake)
endif()

# === SUBDIRECTORIES ===
add_subdirectory(include)           # Interface headers (INTERFACE target)

if(HPC_BUILD_CPU)
    add_subdirectory(cpu)
endif()

if(HPC_BUILD_CUDA OR HPC_BUILD_ROCM OR HPC_BUILD_METAL OR HPC_BUILD_VULKAN)
    add_subdirectory(gpu)
endif()

if(HPC_BUILD_HYBRID)
    if(NOT HPC_BUILD_CPU)
        message(FATAL_ERROR "Hybrid requires CPU backend")
    endif()
    add_subdirectory(hybrid)
endif()

if(HPC_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()

if(HPC_BUILD_BENCH)
    add_subdirectory(benchmarks)
endif()