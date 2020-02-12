#pragma once 
#include "Manager.h"
#include "Gpu.h"
#include <iostream>


class Manager;

//workspace is a table of pointers to matrices
class mWorkspace {
	
private:
	int _size;
	Matrix** _ptr; //pointer to workplace
	Gpu* _GPU;
public:
	Matrix* createMatrix();
	/*Try to create new matrix on given position in workspace*/

	//bool insertMatrix(int position, Matrix* source);
	/*Try to insert given matrix into specified position in workspace*/

	void deleteMatrix();

	void show() const;
	/*Print brief information about actual workspace state*/

	mWorkspace(int size, Gpu*);
	/*Create empty worspace for matrices*/

	void intInput(int* input)const;
	bool inputPosition(int*) const;
	void printMatrix() const;

	void compareMatrices() const;
	void addMatrices(bool cpu, bool gpu, bool timeMeasure) const;
	void substractMatrices(bool cpu, bool gpu, bool timeMeasure) const;
	void multiplyMatrices(bool cpu, bool gpu, bool timeMeasure) const;
	void invertMatrices(bool cpu, bool gpu, bool timeMeasure) const;

	void fillRandom();
	/*Fills matrix with random numbers in provided range*/

	~mWorkspace();
};