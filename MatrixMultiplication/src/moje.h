/*
 * moje.h
 *
 *  Created on: Nov 29, 2019
 *      Author: cuda-s05
 */

#ifndef MOJE_H_
#define MOJE_H_
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>


inline void rand_init(){
    time_t czas;
    srand((unsigned int) time(&czas));
} //umozliwia losowanie liczb

void fill(float *A, int size);//wypelnia macierz losowymi wartosciami
float rand_float (float a, float b); // losuje wartości zmiennoprzecinkowej z zakresu od a do b
void multiply_one(float *A, float *B, float *C, int size);//mnozy 2 macierze na 1 watku
int compare(float *A, float *B, int size); //sprawdza czy dwa wektory sa takie same



#endif /* MOJE_H_ */
