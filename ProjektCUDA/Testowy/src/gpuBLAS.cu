#include "gpuBLAS.h"


__global__ void addKernel(int* A, int* B, int* R, int size) {
    int stride = blockDim.x * gridDim.x;
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    for (; i < size; i+=stride) {
        R[i] = A[i] + B[i];
    }
}

__global__ void subKernel(int* A, int* B, int* R, int size) {
    int stride = blockDim.x * gridDim.x;
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    for (; i < size; i += stride) {
        R[i] = A[i] - B[i];
    }
}

__global__ void dotKernel(int* A, int* B, int* R, int size) {
    int stride = blockDim.x * gridDim.x;
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    for (; i < size; i += stride) {
        R[i] = A[i] * B[i];
    }
}

__global__ void mulKernel(int* A, int* B, int* R, int m, int n, int k) {
    int Col = blockIdx.x * blockDim.x + threadIdx.x;
    int Row = blockIdx.y * blockDim.y + threadIdx.y;

    int sum = 0;
    if ((Row < m) && (Col < k)) {
        
        for (int i = 0; i < n; i++) {
            sum += A[Row * n + i] * B[i * k + Col];
        }
        R[Row * k + Col] = sum;
    }
}

void addGpu(Gpu* GPU,int* h_A, int* h_B, int* h_R, int n) {
    int* d_A, * d_B, * d_R;
    int size = n * sizeof(int);
    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);
    cudaMalloc((void**)&d_R, size);

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    addKernel << <GPU->getGrid(), GPU->getBlock() >> > (d_A, d_B, d_R, n);
    cudaDeviceSynchronize();
    cudaMemcpy(h_R, d_R, size, cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_R);
 
}

void subGpu(Gpu* GPU, int* h_A, int* h_B, int* h_R, int n) {
    int* d_A, * d_B, * d_R;
    int size = n * sizeof(int);
    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);
    cudaMalloc((void**)&d_R, size);

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    subKernel << <GPU->getGrid(), GPU->getBlock() >> > (d_A, d_B, d_R, n);
    cudaDeviceSynchronize();
    cudaMemcpy(h_R, d_R, size, cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_R);
}

int dotGpu(Gpu* GPU, int* h_A, int* h_B, int n) {
    int* d_A, * d_B, * d_R;
    int* h_R = new int[n];
    int size = n * sizeof(int);
    cudaMalloc((void**)&d_A, size);
    cudaMalloc((void**)&d_B, size);
    cudaMalloc((void**)&d_R, size);

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    dotKernel << <GPU->getGrid(), GPU->getBlock() >> > (d_A, d_B, d_R, n);
    cudaDeviceSynchronize();
    cudaMemcpy(h_R, d_R, size, cudaMemcpyDeviceToHost);
    
    int sum = 0;
    for (int i = 0; i < n; i++) {
        sum += h_R[i];
    }

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_R);
    delete h_R;

    return sum;
}

void mulGpu(Gpu* GPU, int* h_A, int* h_B, int* h_R, int m,int n, int k) {
    int* d_A, * d_B, * d_R;
    const int BLOCK_SIZE = 16;
    cudaMalloc((void**)&d_A, m * n * sizeof(int));
    cudaMalloc((void**)&d_B, n * k * sizeof(int));
    cudaMalloc((void**)&d_R, m * k * sizeof(int));

    cudaMemcpy(d_A, h_A, m * n * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, n * k * sizeof(int), cudaMemcpyHostToDevice);

    unsigned int grid_rows = (m + BLOCK_SIZE - 1) / BLOCK_SIZE;
    unsigned int grid_cols = (k + BLOCK_SIZE - 1) / BLOCK_SIZE;
    dim3 dimGrid(grid_cols, grid_rows);
    dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);

    mulKernel << <dimGrid, dimBlock >> > (d_A, d_B, d_R, m, n, k);
    cudaDeviceSynchronize();
    cudaMemcpy(h_R, d_R, m * k * sizeof(int), cudaMemcpyDeviceToHost);
    cudaDeviceSynchronize();

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_R);

}

StopWatchInterface*  startTimer() {
    StopWatchInterface* timer = 0;
    sdkCreateTimer(&timer);
    sdkStartTimer(&timer);
    return timer;
}

void stopTimer(StopWatchInterface* timer) {
    sdkStopTimer(&timer);
    printf("Processing time: %f (ms)\n", sdkGetTimerValue(&timer));
    sdkDeleteTimer(&timer);
}





