#include "gpuBLAS.h"
#include <iostream>

__global__ void helloCuda()
{
    printf("Hello from GPU!");
}