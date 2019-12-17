#include "functions.h"

const int BLOCK_SIZE = 256;

__global__ void sum(float* input, float* output, int size)
{
	__shared__ float partialSum[2 * BLOCK_SIZE];
	unsigned int t = threadIdx.x, start = 2 * blockIdx.x * blockDim.x;
	
	if (start + t < size)
		partialSum[t] = input[start + t];
	else
		partialSum[t] = 0;
	if (start + blockDim.x + t < size)
		partialSum[blockDim.x + t] = input[start + blockDim.x + t];
	else
		partialSum[blockDim.x + t] = 0;

	for (unsigned int stride = 1; stride <= blockDim.x; stride <<= 1) {
		__syncthreads();
		if (t % stride == 0)
			partialSum[2*t] += partialSum[2*t + stride];
	}
	__syncthreads();
	if (t == 0)
		output[blockIdx.x] += partialSum[0];

	

}
void reductionOnGpu(float* h_A, float* h_R, int size) {
	
	sum <<<1, BLOCK_SIZE >>> (h_A, h_R, size);

	//cudaMemcpy(R, h_A, sizeof(float), cudaMemcpyDeviceToHost);
	
}



////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////
	int main(int argc, char** argv) {
		rand_init();
		int size;
		printf("Enter length of vector: ");
		scanf("%d", &size);

		float* A = new float[size];
		fill(A, size);
		printf("***Reduction on CPU***");
		StopWatchInterface* timer = 0;
		sdkCreateTimer(&timer);
		sdkStartTimer(&timer);

		float result = sumArray(A, size);

		sdkStopTimer(&timer);
		printf("Reduction time on CPU: %f (ms)\n", sdkGetTimerValue(&timer));
		sdkDeleteTimer(&timer);

		float* D_A = (float*)malloc(sizeof(float) * size);
		for (int i = 0; i < size; i++) {
			D_A[i] = A[i];
		}

		printf("***Reduction on GPU***\n");
		sdkCreateTimer(&timer);
		sdkStartTimer(&timer);
		
		float D_result = divide(D_A, size);

		sdkStopTimer(&timer);
		printf("Reduction time on GPU: %f (ms)\n", sdkGetTimerValue(&timer));
		sdkDeleteTimer(&timer);

		if (compare(D_result, result)) {
			printf("Results match");
		}
		else {
			printf("Results does not match. CPU: %f GPU: %f", result, D_result);
		}
		
		getchar();
		getchar();
		cudaFree(D_A);
		delete[] A;
		return 0;
	}