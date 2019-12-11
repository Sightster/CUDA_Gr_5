#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

// includes CUDA
#include <cuda_runtime.h>
// includes, project
#include <helper_cuda.h>
#include <helper_functions.h> // helper functions for SDK examples

inline void rand_init() {
	time_t czas;
	srand((unsigned int)time(&czas));
}

float sumArray(float* A, int size);
float rand_float(float a, float b);
void fill(float* A, int size);
bool compare(float x, float y);
float divide(float* A, int size);
void reductionOnGpu(float* A, float* R, int size);