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
	int maxPartSize = BLOCK_SIZE * 2 * 2;
	int numberOfParts = size / maxPartSize + 1;
	float *R = new float [numberOfParts];
	int i = 0;
	for (; i < numberOfParts - 1; i++) {
		reductionOnGpu(A + maxPartSize*i,R + i, maxPartSize);
	}
	reductionOnGpu(A+maxPartSize*i, R + i, size - maxPartSize*i);
	float sum = sumArray(R, numberOfParts);
	delete R;
	return sum;
}