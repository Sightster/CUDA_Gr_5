/*
 * moje.c
 *
 *  Created on: Nov 29, 2019
 *      Author: cuda-s05
 */

#include "moje.h"

#define EPSILON 10

float rand_float (float a, float b){

  return (a + (rand()/(1.0 * RAND_MAX)) *(b-a));

  }

void fill(float *A, int size){
	int i;
	for(i = 0; i<size; i++){
		A[i] = rand_float(0.0, 10.0);
	}

}

void multiply_one(float *A, float *B, float *C, int width){

	 float sum;
	 int row,col,n;
	    for (row=0; row<width; row++){
	        for (col=0; col<width; col++){
	            sum = 0.f;
	            for (n=0; n<width; n++){
	                sum += A[row*width+n]*B[n*width+col];
	            }
	            C[row*width+col] = sum;
	        }
	    }

}

int compare(float *A, float *B, int size){
	int i;
	for(i = 0; i<size; i++){
		if(!(fabs(A[i] - B[i]) < EPSILON)){
			return 0;
		}
	}
	return 1;
}
