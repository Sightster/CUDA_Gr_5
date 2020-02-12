#pragma once 
#include "Manager.h"
#include "Gpu.h"
#include <iostream>


class Manager;

//workspace is a table of pointers to vectors 
class vWorkspace {
	
private:
	int _size;
	Vector** _ptr; //pointer to workspace
	Gpu* _GPU;

public:
	Vector* createVector();
	/*Try to create new vector on given position in worspace*/

	//bool insertVector(int position, Vector*);
	/*Try to insert given vector into specify position in worspace*/

	void deleteVector();

	void show() const;
	/*Print brief information about actual workspace state*/

	vWorkspace(int size, Gpu*);
	/*Create empty workspace for vectors*/

	void printVector() const;

	void fillRandom();
	/*Fills vector with random numbers in provided range*/

	void intInput(int* input) const; //get int value from user
	bool inputPosition(int*) const;

	void compareVectors() const;
	void addVectors(bool cpu, bool gpu, bool timeMeasure) const;
	void substractVectors(bool cpu, bool gpu, bool timeMeasure) const;
	void dotProductVectors(bool cpu, bool gpu, bool timeMeasure) const;


	~vWorkspace();
};

