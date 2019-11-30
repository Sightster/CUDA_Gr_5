////////////////////////////////////////////////////////////////////////////
//
// Copyright 1993-2015 NVIDIA Corporation.  All rights reserved.
//
// Please refer to the NVIDIA end user license agreement (EULA) associated
// with this source code for terms and conditions that govern your use of
// this software. Any use, reproduction, disclosure, or distribution of
// this software and related documentation outside the terms of the EULA
// is strictly prohibited.
//
////////////////////////////////////////////////////////////////////////////

/* Template project which demonstrates the basics on how to setup a project
* example application.
* Host code.
*/

// includes, system
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>


#include "moje.c"
#define BLOCK_SIZE 16
#define TILE_DIM 16
#include <cublas_v2.h>
// includes CUDA
#include <cuda_runtime.h>

// includes, project
#include <helper_cuda.h>
#include <helper_functions.h> // helper functions for SDK examples

////////////////////////////////////////////////////////////////////////////////

void MatrixMulcuBLAS(const float *A, const float *B, float *C, const int width);

/*
 * Kernele
 */
__global__ void MatrixMulShared(float* A, float* B, float* R,int width){
	 float sum = 0;

	    int Row = blockIdx.y*TILE_DIM + threadIdx.y;
	    int Col = blockIdx.x*TILE_DIM + threadIdx.x;

	    __shared__ float As[TILE_DIM][TILE_DIM];
	    __shared__ float Bs[TILE_DIM][TILE_DIM];

	    for (int k = 0; k < (TILE_DIM + width - 1)/TILE_DIM; k++) {

	         if (k*TILE_DIM + threadIdx.x < width && Row < width)
	             As[threadIdx.y][threadIdx.x] = A[Row*width + k*TILE_DIM + threadIdx.x];
	         else
	             As[threadIdx.y][threadIdx.x] = 0.0;

	         if (k*TILE_DIM + threadIdx.y < width && Col < width)
	             Bs[threadIdx.y][threadIdx.x] = B[(k*TILE_DIM + threadIdx.y)*width + Col];
	         else
	             Bs[threadIdx.y][threadIdx.x] = 0.0;

	         __syncthreads();

	         for (int n = 0; n < TILE_DIM; ++n)
	             sum += As[threadIdx.y][n] * Bs[n][threadIdx.x];

	         __syncthreads();
	    }

	    if (Row < width && Col < width)
	        R[((blockIdx.y * blockDim.y + threadIdx.y)*width) +
	           (blockIdx.x * blockDim.x)+ threadIdx.x] = sum;
}

__global__ void MatrixMulNaive(float* A, float* B, float* R, int width){
	int Row = blockIdx.x*blockDim.x+threadIdx.x;
	int Col = blockIdx.y*blockDim.y+threadIdx.y;


	if((Row < width) &&(Col < width)){
		float sum = 0;
		for(int i = 0; i < width; i++){
			sum += A[Row * width + i] * B[i * width + Col];
		}
		R[Row * width + Col] = sum;
	}
}
////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////
int
main(int argc, char **argv)
{

	void rand_init();
	cudaError_t err = cudaSuccess;

	  int width;
	  printf("Set width of matrix: ");
	  scanf("%d",&width);
	  int size = width * width;

	  //preparing data
	  float *h_A = (float*)malloc(sizeof(float) * size);
	  float *h_B = (float*)malloc(sizeof(float) * size);
	  if (h_A == NULL || h_B == NULL)
	      {
	          fprintf(stderr, "Failed to allocate data vectors!\n");
	          exit(EXIT_FAILURE);
	      }
	  fill(h_A, size);
	  fill(h_B, size);

	  //Results vectors
	  float *h_ROne = (float*)malloc(sizeof(float) * size);
	  float *h_RNaive = (float*)malloc(sizeof(float) * size);
	  float *h_RShared = (float*)malloc(sizeof(float) * size);
	  float *h_RcuBLAS = (float*)malloc(sizeof(float) * size);
	  if(h_ROne == NULL || h_RNaive == NULL || h_RShared == NULL || h_RcuBLAS == NULL){
		  fprintf(stderr, "Failed to allocate results vectors!\n");
		  exit(EXIT_FAILURE);
	  }

	  printf("\n***Multiply on CPU***\n");
	  //matrix multiplication on CPU
	  StopWatchInterface *timer = 0;
	  sdkCreateTimer(&timer);
	  sdkStartTimer(&timer);

	  multiply_one(h_A, h_B, h_ROne, width);

	  sdkStopTimer(&timer);
	  printf("Processing time multiply_one: %f (ms)\n", sdkGetTimerValue(&timer));
	  sdkDeleteTimer(&timer);

	  //allocating vectors on GPU
	  float *d_A = NULL;
	      err = cudaMalloc((void **)&d_A, size * sizeof(float));

	      if (err != cudaSuccess)
	      {
	          fprintf(stderr, "Failed to allocate device vector A (error code %s)!\n", cudaGetErrorString(err));
	          exit(EXIT_FAILURE);
	      }

	   float *d_B = NULL;
	      err = cudaMalloc((void **)&d_B, size * sizeof(float));

	      if (err != cudaSuccess)
	      {
	          fprintf(stderr, "Failed to allocate device vector B (error code %s)!\n", cudaGetErrorString(err));
	          exit(EXIT_FAILURE);
	      }

	   float *d_RNaive = NULL;
	      err = cudaMalloc((void **)&d_RNaive, size * sizeof(float));

	      if (err != cudaSuccess)
	      {
	          fprintf(stderr, "Failed to allocate device vector RNaive (error code %s)!\n", cudaGetErrorString(err));
	          exit(EXIT_FAILURE);
	      }

	      //copying data
	      printf("Copy input data from the host memory to the CUDA device\n");
	          err = cudaMemcpy(d_A, h_A, size*sizeof(float), cudaMemcpyHostToDevice);

	          if (err != cudaSuccess)
	          {
	              fprintf(stderr, "Failed to copy vector A from host to device (error code %s)!\n", cudaGetErrorString(err));
	              exit(EXIT_FAILURE);
	          }

	          err = cudaMemcpy(d_B, h_B, size*sizeof(float), cudaMemcpyHostToDevice);

	          if (err != cudaSuccess)
	          {
	              fprintf(stderr, "Failed to copy vector B from host to device (error code %s)!\n", cudaGetErrorString(err));
	              exit(EXIT_FAILURE);
	          }

	          /*int threadsPerBlock = 512;
	          int blocksPerGrid = 2;*/
	          unsigned int grid_rows = (width + BLOCK_SIZE - 1) / BLOCK_SIZE;
	          unsigned int grid_cols = (width + BLOCK_SIZE - 1) / BLOCK_SIZE;
	          dim3 dimGrid(grid_cols, grid_rows);
	          dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
	          printf("\n***Multiply on GPU NAIVE***\n");
	          sdkCreateTimer(&timer);
	          sdkStartTimer(&timer);
	          MatrixMulNaive<<<dimGrid, dimBlock>>>(d_A, d_B, d_RNaive, width);
	              err = cudaGetLastError();

	              if (err != cudaSuccess)
	              {
	                  fprintf(stderr, "Failed to launch MatrixMulNaive kernel (error code %s)!\n", cudaGetErrorString(err));
	                  exit(EXIT_FAILURE);
	              }

	              // Copy the device result vector in device memory to the host result vector
	              // in host memory.
	              printf("Copy output data from the CUDA device to the host memory\n");
	              cudaDeviceSynchronize();
	              err = cudaMemcpy(h_RNaive, d_RNaive, size*sizeof(float), cudaMemcpyDeviceToHost);

	              if (err != cudaSuccess)
	              {
	                  fprintf(stderr, "Failed to copy vector RNaive from device to host (error code %s)!\n", cudaGetErrorString(err));
	                  exit(EXIT_FAILURE);
	              }

	              sdkStopTimer(&timer);
	              printf("Processing time MatrixMulNaive: %f (ms)\n", sdkGetTimerValue(&timer));
	              sdkDeleteTimer(&timer);

	              if(compare(h_ROne, h_RNaive, size)){
	            	  printf("Vector ROne and RNaive match\n");
	              }else{
	            	  printf("Vector ROne and RNaive does not match\n");
	              }
	              cudaFree(d_RNaive);

	              printf("\n***Multiply on GPU cuBLAS***\n");
	              float *d_RcuBLAS = NULL;
	              err = cudaMalloc((void **)&d_RcuBLAS, size * sizeof(float));

	              if (err != cudaSuccess)
	              {
	              	 fprintf(stderr, "Failed to allocate device vector RcuBLAS (error code %s)!\n", cudaGetErrorString(err));
	              	 exit(EXIT_FAILURE);
	              }
	              sdkCreateTimer(&timer);
	              sdkStartTimer(&timer);

	              MatrixMulcuBLAS(d_B, d_A, d_RcuBLAS, width);

	              cudaDeviceSynchronize();
	              err = cudaMemcpy(h_RcuBLAS, d_RcuBLAS, size*sizeof(float), cudaMemcpyDeviceToHost);

	              if (err != cudaSuccess)
	              {
	            	  fprintf(stderr, "Failed to copy vector RcuBLAS from device to host (error code %s)!\n", cudaGetErrorString(err));
	            	  exit(EXIT_FAILURE);
	              }
	              sdkStopTimer(&timer);
	              printf("Processing time MatrixMulcuBLAS: %f (ms)\n", sdkGetTimerValue(&timer));
	              sdkDeleteTimer(&timer);
	              cudaFree(d_RcuBLAS);

	              if(compare(h_ROne, h_RcuBLAS, size)){
	            	  printf("Vector ROne and RcuBLAS match\n");
	              }else{
	              	  printf("Vector ROne and RcuBLAS does not match\n");
	              }

	              printf("\n***Multiply on GPU SHARED***\n");
	              float *d_RShared = NULL;
	              err = cudaMalloc((void **)&d_RShared, size * sizeof(float));

	              if (err != cudaSuccess)
	              {
	            	  fprintf(stderr, "Failed to allocate device vector RShared (error code %s)!\n", cudaGetErrorString(err));
	              	  exit(EXIT_FAILURE);
	              }
	              sdkCreateTimer(&timer);
	              sdkStartTimer(&timer);

	              MatrixMulShared<<<dimGrid, dimBlock>>>(d_A, d_B, d_RShared, width);
	              err = cudaGetLastError();

	              if (err != cudaSuccess)
	              {
	            	  fprintf(stderr, "Failed to launch MatrixMulShared kernel (error code %s)!\n", cudaGetErrorString(err));
	              	  exit(EXIT_FAILURE);
	              }
	              printf("Copy output data from the CUDA device to the host memory\n");
	              cudaDeviceSynchronize();
	              err = cudaMemcpy(h_RShared, d_RShared, size*sizeof(float), cudaMemcpyDeviceToHost);

	              if (err != cudaSuccess)
	              {
	            	  fprintf(stderr, "Failed to copy vector RShared from device to host (error code %s)!\n", cudaGetErrorString(err));
	              	  exit(EXIT_FAILURE);
	              }

	              sdkStopTimer(&timer);
	              printf("Processing time MatrixMulShared: %f (ms)\n", sdkGetTimerValue(&timer));
	              sdkDeleteTimer(&timer);

	              if(compare(h_ROne, h_RShared, size)){
	            	  printf("Vector ROne and RShared match\n");
	              }else{
	              	  printf("Vector ROne and RShared does not match\n");
	              }
	              cudaFree(d_RShared);



	  cudaFree(d_A);
	  cudaFree(d_B);
	  free(h_A);
	  free(h_B);
	  free(h_ROne);
	  free(h_RNaive);
	  free(h_RShared);
	  free(h_RcuBLAS);

}

void MatrixMulcuBLAS(const float *A, const float *B, float *R, const int width){
	int lda,ldb,ldr;
	lda = ldb = ldr = width;

	const float alf = 1;
	const float bet = 0;
	const float* alpha = &alf;
	const float* beta = &bet;

	cublasHandle_t handle;
	cublasCreate(&handle);
	cublasSgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, width, width, width, alpha, A, lda, B, ldb, beta, R, ldr);

	cublasDestroy(handle);
}

