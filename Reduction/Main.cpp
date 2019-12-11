/* Template project which demonstrates the basics on how to setup a project
* example application.
* Host code.
*/

// includes, system

#include "functions.h"

//const int BLOCK_SIZE = 256;

__global__ void sum(float* input, float* output, int size)
{
	const int t = threadIdx.x;

	auto step = 1;
	int number_of_threads = blockDim.x;

	while (number_of_threads > 0)
	{
		if (t < number_of_threads) 
		{
			const auto fst = t * step * 2;
			const auto snd = fst + step;
			input[fst] += input[snd];
		}

		step <<= 1;
		number_of_threads >>= 1;
	}
	/*__shared__ float partialSum[2 * BLOCK_SIZE];
	unsigned int t = threadIdx.x, start = 2 * blockIdx.x * BLOCK_SIZE;

	if (start + t < size)
		partialSum[t] = input[start + t];
	else
		partialSum[t] = 0;
	if (start + BLOCK_SIZE + t < size)
		partialSum[BLOCK_SIZE + t] = input[start + BLOCK_SIZE + t];
	else
		partialSum[BLOCK_SIZE + t] = 0;

	for (unsigned int stride = BLOCK_SIZE; stride >= 1; stride >>= 1) {
		__syncthreads();
		if (t < stride)
			partialSum[t] += partialSum[t + stride];
	}

	if (t == 0)
		output[blockIdx.x] = partialSum[0];*/

}
void reductionOnGpu(float* A, float* R, int size) {
	float* h_A;
	cudaMalloc(&h_A, size * sizeof(float));
	cudaMemcpy(h_A, A, size * sizeof(float), cudaMemcpyHostToDevice);

	sum << <1, size >> > (h_A, R, size);

	cudaMemcpy(R, h_A, sizeof(float), cudaMemcpyDeviceToHost);
	cudaFree(h_A);
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
		

		cudaFree(D_A);
		delete[] A;
		return 0;
	}

		
