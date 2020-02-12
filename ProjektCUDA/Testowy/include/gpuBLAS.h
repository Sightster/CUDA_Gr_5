#pragma once
#include "Gpu.h"
#include <iostream>
#include "helper_functions.h"

__global__ void addKernel(int* A, int* B, int* R, int size);
__global__ void subKernel(int* A, int* B, int* R, int size);
__global__ void dotKernel(int* A, int* B, int* R, int size);
__global__ void mulKernel(int* A, int* B, int* R, int width, int n, int length);

void addGpu(Gpu*,int* h_A, int* h_B, int* h_R, int n);
void subGpu(Gpu*, int* h_A, int* h_B, int* h_R, int n);
void mulGpu(Gpu*, int* h_A, int* h_B, int* h_R, int width, int n, int length);
int dotGpu(Gpu* , int* h_A, int* h_B, int n);



StopWatchInterface* startTimer();
void stopTimer(StopWatchInterface* timer);