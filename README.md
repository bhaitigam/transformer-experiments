# HPC Project

High-performance computing library with strict CPU/GPU separation, written in C with CMake build system. Zero-overhead abstractions, cache-aware algorithms, and runtime SIMD/GPU dispatch.

[![CI](https://github.com/yourorg/hpc_project/actions/workflows/ci.yml/badge.svg)](https://github.com/yourorg/hpc_project/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Quick Start

```bash
# Clone
git clone --recursive https://github.com/yourorg/hpc_project.git
cd hpc_project

# CPU only
cmake -B build -S . -DHPC_BUILD_CPU=ON
cmake --build build -j$(nproc)

# CPU + CUDA (requires NVIDIA GPU + CUDA Toolkit)
cmake -B build -S . \
    -DHPC_BUILD_CPU=ON \
    -DHPC_BUILD_CUDA=ON \
    -DHPC_BUILD_HYBRID=ON \
    -DCMAKE_CUDA_ARCHITECTURES="80;86;89"
cmake --build build -j$(nproc)

# Run tests
ctest --test-dir build --output-on-failure