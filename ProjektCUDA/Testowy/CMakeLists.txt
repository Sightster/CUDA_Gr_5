# CMakeList.txt : CMake project for Testowy, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.8)

project (BLAS LANGUAGES CXX CUDA)

if(NOT DEFINED CMAKE_CUDA_STANDARD)
    set(CMAKE_CUDA_STANDARD 11)
    set(CMAKE_CUDA_STANDARD_REQUIRED ON)
endif()

# prevent for in-source building
#set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)
#set(CMAKE_DISABLE_SOURCE_CHANGES  ON)
#if ("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
 # message(SEND_ERROR "In-source builds are not allowed.")
#endif ()

set(PROJECT_LINK_DIRECTORY ${PROJECT_SOURCE_DIR})
set(PATH_TO_CUDA_SAMPLES "C:\\ProgramData\\NVIDIA Corporation\\CUDA Samples\\v10.1\\common\\inc")
set(PATH_TO_CUBLAS "C:\\Program Files\\NVIDIA GPU Computing Toolkit\\CUDA\\v10.1\\include")

include_directories(${PROJECT_SOURCE_DIR}/include ${PATH_TO_CUDA_SAMPLES} ${PATH_TO_CUBLAS})

file(GLOB SOURCES ${PROJECT_SOURCE_DIR}/src/*.c*)


# Add source to this project's executable.
#add_executable (Testowy "Testowy.cpp" "Testowy.h")
add_executable(${PROJECT_NAME} Main.cu ${SOURCES})

# TODO: Add tests and install targets if needed.
