```bat
@echo off
title Transformer Experiments HPC Structure

REM =========================================================
REM CREATE TRANSFORMER-EXPERIMENTS INSIDE EXISTING HPC TREE
REM =========================================================

set PROJECT=transformer-experiments

mkdir %PROJECT%
cd %PROJECT%

REM =========================================================
REM ROOT
REM =========================================================

type nul > CMakeLists.txt
type nul > README.md

REM =========================================================
REM CMAKE
REM =========================================================

mkdir cmake
mkdir cmake\modules
mkdir cmake\toolchains

type nul > cmake\modules\FindCUDAArch.cmake
type nul > cmake\modules\FindROCm.cmake
type nul > cmake\modules\FindMetal.cmake
type nul > cmake\modules\FindVulkanCompute.cmake

type nul > cmake\toolchains\gcc-native.cmake
type nul > cmake\toolchains\clang-native.cmake
type nul > cmake\toolchains\arm-neon.cmake

type nul > cmake\compiler_options.cmake
type nul > cmake\cpu_features.cmake
type nul > cmake\gpu_arch.cmake
type nul > cmake\sanitizers.cmake
type nul > cmake\profiling.cmake
type nul > cmake\install_rules.cmake

REM =========================================================
REM INCLUDE
REM =========================================================

mkdir include\transformer
mkdir include\transformer\core
mkdir include\transformer\tensor
mkdir include\transformer\attention
mkdir include\transformer\models
mkdir include\transformer\tokenizer
mkdir include\transformer\training
mkdir include\transformer\inference
mkdir include\transformer\gpu

type nul > include\transformer\core\config.h
type nul > include\transformer\core\types.h
type nul > include\transformer\core\memory.h

type nul > include\transformer\tensor\tensor.h
type nul > include\transformer\tensor\shape.h

type nul > include\transformer\attention\self_attention.h
type nul > include\transformer\attention\flash_attention.h

type nul > include\transformer\models\gpt.h
type nul > include\transformer\models\bert.h
type nul > include\transformer\models\llama.h

type nul > include\transformer\tokenizer\bpe.h
type nul > include\transformer\tokenizer\vocab.h

type nul > include\transformer\training\optimizer.h
type nul > include\transformer\training\loss.h

type nul > include\transformer\inference\sampler.h
type nul > include\transformer\inference\kv_cache.h

type nul > include\transformer\gpu\cuda_kernels.h

REM =========================================================
REM SRC
REM =========================================================

mkdir src
mkdir src\core
mkdir src\tensor
mkdir src\attention
mkdir src\models
mkdir src\tokenizer
mkdir src\training
mkdir src\inference
mkdir src\cpu
mkdir src\gpu

type nul > src\core\memory.cpp
type nul > src\core\logger.cpp

type nul > src\tensor\tensor.cpp
type nul > src\tensor\shape.cpp

type nul > src\attention\self_attention.cpp
type nul > src\attention\flash_attention.cpp
type nul > src\attention\multi_head_attention.cpp

type nul > src\models\gpt.cpp
type nul > src\models\bert.cpp
type nul > src\models\llama.cpp

type nul > src\tokenizer\bpe.cpp
type nul > src\tokenizer\vocab.cpp

type nul > src\training\adam.cpp
type nul > src\training\cross_entropy.cpp

type nul > src\inference\sampler.cpp
type nul > src\inference\kv_cache.cpp

type nul > src\cpu\avx_attention.cpp
type nul > src\cpu\openmp_transformer.cpp

type nul > src\gpu\attention.cu
type nul > src\gpu\matmul.cu
type nul > src\gpu\layernorm.cu
type nul > src\gpu\softmax.cu

REM =========================================================
REM EXPERIMENTS
REM =========================================================

mkdir experiments
mkdir experiments\gpt
mkdir experiments\bert
mkdir experiments\llama
mkdir experiments\vision_transformer
mkdir experiments\multimodal

type nul > experiments\gpt\train_gpt.cpp
type nul > experiments\bert\train_bert.cpp
type nul > experiments\llama\train_llama.cpp
type nul > experiments\vision_transformer\vit.cpp

REM =========================================================
REM BENCHMARKS
REM =========================================================

mkdir benchmarks

type nul > benchmarks\bench_attention.cpp
type nul > benchmarks\bench_matmul.cpp
type nul > benchmarks\bench_inference.cpp

REM =========================================================
REM TESTS
REM =========================================================

mkdir tests
mkdir tests\unit
mkdir tests\integration
mkdir tests\gpu

type nul > tests\unit\test_tensor.cpp
type nul > tests\unit\test_attention.cpp
type nul > tests\integration\test_pipeline.cpp
type nul > tests\gpu\test_cuda_attention.cu

REM =========================================================
REM DATA
REM =========================================================

mkdir data
mkdir data\tokenizers
mkdir data\datasets
mkdir data\checkpoints

REM =========================================================
REM MODELS
REM =========================================================

mkdir models
mkdir models\gpt
mkdir models\bert
mkdir models\llama

REM =========================================================
REM PYTHON
REM =========================================================

mkdir python
mkdir python\scripts
mkdir python\bindings

type nul > python\scripts\convert_weights.py
type nul > python\scripts\train.py
type nul > python\bindings\pybind.cpp

REM =========================================================
REM DOCS
REM =========================================================

mkdir docs
mkdir docs\architecture
mkdir docs\attention
mkdir docs\optimization
mkdir docs\cuda

REM =========================================================
REM THIRD PARTY
REM =========================================================

mkdir third_party
mkdir third_party\googletest
mkdir third_party\fmt
mkdir third_party\eigen
mkdir third_party\sentencepiece

REM =========================================================
REM BUILD
REM =========================================================

mkdir build
mkdir install

echo.
echo ===============================================
echo TRANSFORMER-EXPERIMENTS STRUCTURE CREATED
echo ===============================================
pause
```
