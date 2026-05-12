High-Performance C + GPU Project Structure (CMake)

hpc_project/
│
├── CMakeLists.txt              # Root: options, backends, orchestration
├── README.md
├── cmake/
│   ├── modules/
│   │   ├── FindCUDAArch.cmake      # Auto-detect GPU architectures
│   │   ├── FindROCm.cmake          # AMD HIP detection
│   │   ├── FindMetal.cmake         # Apple Metal SDK
│   │   └── FindVulkanCompute.cmake # Vulkan for compute
│   │
│   ├── toolchains/
│   │   ├── gcc-native.cmake        # x86-64 with all CPU flags
│   │   ├── clang-native.cmake
│   │   └── arm-neon.cmake
│   │
│   ├── compiler_options.cmake      # Aggressive optimization flags
│   ├── cpu_features.cmake          # CPUID detection at configure
│   ├── gpu_arch.cmake              # GPU arch selection
│   ├── sanitizers.cmake            # ASan, UBSan, TSan
│   ├── profiling.cmake             # perf, nvtx, roctx
│   └── install_rules.cmake         # GNUInstallDirs, pkg-config
│
├── include/                      # SHARED PUBLIC HEADERS (C ABI)
│   └── hpc/
│       ├── core/
│       │   ├── types.h             # Fixed-width, alignas, result_t
│       │   ├── compiler.h          # likely/unlikely, inline, hot/cold
│       │   ├── memory.h            # Aligned alloc, huge pages, NUMA
│       │   ├── cache.h             # Cache line, prefetch, fence
│       │   └── atomics.h           # C11 _Atomic, lock-free checks
│       │
│       ├── math/
│       │   ├── fast_math.h         # Approximations, LUT declarations
│       │   └── vector_types.h      # float4, float8, half precision
│       │
│       ├── io/
│       │   ├── mmap.h              # Zero-copy file I/O
│       │   └── arena.h             # Bump allocator interface
│       │
│       └── interface/              # CPU <-> GPU CONTRACT
│           ├── buffer.h            # Shared buffer descriptor
│           ├── kernel_args.h       # Packed kernel argument structs
│           ├── dispatch.h          # Async job submission API
│           └── event.h             # Completion events, callbacks
│
├── cpu/                          # ========== CPU ONLY ==========
│   │
│   ├── CMakeLists.txt            # Object library + static lib
│   │
│   ├── include/
│   │   └── cpu_internal/
│   │       ├── simd_detect.h         # CPUID, feature flags
│   │       ├── simd_dispatch.h       # Function pointer tables
│   │       ├── simd_sse2.h
│   │       ├── simd_avx2.h
│   │       ├── simd_avx512f.h
│   │       ├── simd_avx512vl.h
│   │       └── simd_neon.h
│   │
│   ├── src/
│   │   ├── core/
│   │   │   ├── memory.c              # Aligned malloc, arena, pools
│   │   │   ├── arena.c               # Frame allocator (no free)
│   │   │   ├── numa.c                # Linux numa.h, first-touch
│   │   │   └── error.c               # Error codes, no exit
│   │   │
│   │   ├── math/
│   │   │   ├── fast_sqrt.c           # rsqrt, Newton iteration
│   │   │   └── simd_math_dispatch.c  # Vectorized via dispatch table
│   │   │
│   │   ├── algo/
│   │   │   ├── sort/
│   │   │   │   ├── qsort.c           # Introsort, median-of-3
│   │   │   │   ├── radix_sort.c      # LSD, cache-oblivious
│   │   │   │   ├── merge_sort.c      # Bottom-up, tiled
│   │   │   │   └── parallel_sort.c   # OpenMP task-based
│   │   │   │
│   │   │   ├── search/
│   │   │   │   ├── binary_search.c   # Branchless, prefetch
│   │   │   │   └── hash_table.c      # Robin Hood, flat array
│   │   │   │
│   │   │   └── string/
│   │   │       ├── memcpy.c          # REP MOVSB vs AVX-512 heuristic
│   │   │       └── memset.c
│   │   │
│   │   └── simd/
│   │       ├── dispatch.c            # Runtime CPU detection
│   │       ├── sse2_math.c
│   │       ├── avx2_math.c
│   │       └── avx512_math.c
│   │
│   ├── benchmarks/
│   │   ├── CMakeLists.txt
│   │   ├── bench_sort.c
│   │   ├── bench_hash.c
│   │   └── bench_memcpy.c
│   │
│   └── tests/
│       ├── CMakeLists.txt
│       ├── test_sort.c
│       ├── test_hash.c
│       └── fuzz_hash.c               # libFuzzer harness
│
├── gpu/                          # ========== GPU ONLY ==========
│   │
│   ├── CMakeLists.txt            # Backend selection, no cross-contamination
│   │
│   ├── cuda/                     # NVIDIA CUDA backend
│   │   ├── CMakeLists.txt
│   │   │
│   │   ├── include/
│   │   │   └── cuda_internal/
│   │   │       ├── kernels.h         # __global__ declarations
│   │   │       ├── warp_ops.cuh      # Shuffle, ballot, reduce
│   │   │       └── cooperative_groups.cuh
│   │   │
│   │   ├── src/
│   │   │   ├── kernels/
│   │   │   │   ├── sort.cu           # Bitonic, merge, radix
│   │   │   │   ├── reduce.cu         # Warp shuffle, block reduce
│   │   │   │   ├── scan.cu           # Blelloch parallel prefix sum
│   │   │   │   ├── gemm.cu           # WMMA, tensor cores
│   │   │   │   └── conv.cu           # Im2col, Winograd
│   │   │   │
│   │   │   ├── memory/
│   │   │   │   ├── cuda_malloc.cu    # cudaMalloc, cudaMallocManaged
│   │   │   │   ├── cuda_memcpy.cu    # Async H2D/D2H/D2D
│   │   │   │   └── cuda_pool.cu      # Memory pool, suballocation
│   │   │   │
│   │   │   └── runtime/
│   │   │       ├── stream.cu         # CUDA streams, priorities
│   │   │       ├── event.cu          # Timing, synchronization
│   │   │       └── graph.cu          # CUDA graphs, replay
│   │   │
│   │   ├── benchmarks/
│   │   │   ├── bench_sort.cu
│   │   │   └── bench_gemm.cu
│   │   │
│   │   └── tests/
│   │       ├── test_reduce.cu
│   │       └── test_gemm.cu
│   │
│   ├── rocm/                     # AMD HIP/ROCm backend
│   │   ├── CMakeLists.txt
│   │   │
│   │   ├── include/
│   │   │   └── rocm_internal/
│   │   │       └── kernels.h
│   │   │
│   │   ├── src/
│   │   │   ├── kernels/
│   │   │   │   ├── sort.hip
│   │   │   │   ├── reduce.hip
│   │   │   │   └── gemm.hip
│   │   │   │
│   │   │   └── memory/
│   │   │       └── hip_malloc.hip
│   │   │
│   │   └── tests/
│   │       └── test_reduce.hip
│   │
│   ├── metal/                    # Apple Metal backend
│   │   ├── CMakeLists.txt
│   │   │
│   │   ├── shaders/
│   │   │   ├── sort.metal
│   │   │   └── reduce.metal
│   │   │
│   │   └── src/
│   │       └── runtime/
│   │           └── command_queue.m
│   │
│   └── vulkan/                   # Vulkan compute backend
│       ├── CMakeLists.txt
│       │
│       ├── shaders/
│       │   ├── sort.comp           # GLSL compute
│       │   └── reduce.comp
│       │
│       └── src/
│           ├── pipeline.c          # Shader modules, descriptor sets
│           ├── memory.c            # Device memory, barriers
│           └── queue.c             # Command buffers, submission
│
├── hybrid/                       # ========== CPU+GPU ORCHESTRATION ==========
│   │
│   ├── CMakeLists.txt            # Links cpu + selected gpu backend
│   │
│   ├── include/
│   │   └── hybrid/
│   │       ├── scheduler.h         # Work splitting heuristic
│   │       ├── pipeline.h          # Multi-stage async pipeline
│   │       └── fallback.h          # GPU fail -> CPU fallback
│   │
│   ├── src/
│   │   ├── scheduler.c             # Data size -> device selection
│   │   ├── pipeline.c              # Producer-consumer across devices
│   │   └── fallback.c              # Graceful degradation
│   │
│   ├── benchmarks/
│   │   └── bench_hybrid.c          # Concurrent CPU+GPU execution
│   │
│   └── tests/
│       └── test_scheduler.c
│
├── benchmarks/                   # Cross-component benchmarks
│   ├── CMakeLists.txt
│   └── end_to_end/
│       ├── e2e_sort.c
│       └── e2e_gemm.c
│
├── tests/                        # Integration tests
│   ├── CMakeLists.txt
│   └── integration/
│       ├── test_cpu_gpu_roundtrip.c
│       └── test_pipeline.c
│
├── tools/                        # Development utilities
│   ├── cpuid.c                   # CPU feature detection binary
│   ├── nvcc_flags.sh             # CUDA arch detection script
│   └── profile.py                # perf/nvprof/nsys wrapper
│
├── docs/
│   ├── architecture/
│   ├── optimization_guides/
│   └── api_reference/
│
├── third_party/                  # Git submodules or FetchContent
│   ├── googletest/               # Optional: tests
│   ├── googlebenchmark/          # Optional: benchmarks
│   └── fmt/                      # Optional: formatting
│
├── build/                        # CMake build directory (gitignored)
└── install/                      # Install prefix (gitignored)