#include "functions.h"

const float epsilon = 10.0;
const int BLOCK_SIZE = 256;
float sumArray(float* A, int size) {
	float sum = 0;
	for (int i = 0; i < size; i++) {
		sum += A[i];
	}
	return sum;
}

float rand_float(float a, float b) {

	return (a + (rand() / (1.0 * RAND_MAX)) * (b - a));

}

void fill(float* A, int size) {
	for (int i = 0; i < size; i++) {
		A[i] = rand_float(0.0, 10.0);
	}
}

bool compare(float x, float y) {
	return fabs(x - y) < epsilon;
}

float divide(float* A, int size) {
	int maxPartSize = BLOCK_SIZE * 2;
	int numberOfParts = size / maxPartSize + 1;
	float *R = new float [numberOfParts];
	for (int i = 0; i < numberOfParts; i++) {
		R[i] = 0;
	}
	float* h_R, *h_A;
	cudaMalloc(&h_R, numberOfParts * sizeof(float));
	cudaMemcpy(h_R, R, numberOfParts * sizeof(float), cudaMemcpyHostToDevice);
	int i = 0;
	cudaMalloc(&h_A, size * sizeof(float));
	cudaMemcpy(h_A, A, size * sizeof(float), cudaMemcpyHostToDevice);
	for (; i < numberOfParts - 1; i++) {
		reductionOnGpu(h_A + maxPartSize*i,h_R, maxPartSize);
	}
	reductionOnGpu(h_A+maxPartSize*i, h_R + i, size - maxPartSize*i);
	cudaMemcpy(R, h_R, numberOfParts * sizeof(float), cudaMemcpyDeviceToHost);

	float sum;
	 
	sum = sumArray(R, numberOfParts);
	
	
	cudaFree(h_R);
	cudaFree(h_A);
	delete R;
	return sum;
}



