# Aggressive optimization for release
set(HPC_CPU_FLAGS
    -O3
    -march=native
    -mtune=native
    -ffast-math
    -funroll-loops
    -fomit-frame-pointer
    -fno-stack-protector        # Remove for security-critical
    -DNDEBUG
)

# LTO
if(HPC_ENABLE_LTO AND CMAKE_C_COMPILER_ID MATCHES "GNU|Clang")
    add_compile_options(-flto=auto)
    add_link_options(-flto=auto)
endif()

# Position-independent code for static libs that may become shared
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Strict warnings for CPU code
set(HPC_CPU_WARNINGS
    -Wall
    -Wextra
    -Werror=implicit-function-declaration
    -Werror=return-type
    -Wstrict-prototypes
    -Wmissing-prototypes
)