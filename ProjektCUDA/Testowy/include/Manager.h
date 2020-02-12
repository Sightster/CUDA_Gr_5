#pragma once
#include "Vector.h"
#include "Matrix.h"
#include "gpuBLAS.h"
#include "VWorkspace.h"
#include "MWorkspace.h"
#include "Gpu.h"

#include <iostream>

class vWorkspace;
class mWorkspace;
class Gpu;

class Manager {
	
	//friend void addGpu();
private:
	vWorkspace* _vectors;
	mWorkspace* _matrices;
	Gpu* _GPU;

	bool _cpu;
	bool _gpu;
	bool _timeMeasure;
	int _gridSize;
	int _blockSize;

public:

	void mainMenu();
	void confMenu();
	void dataMenu();
	void calculateVectorsMenu();
	void calculateMatricesMenu();
	void showMenu();

	vWorkspace* vectors() const;
	mWorkspace* matrices() const;

	void changeSizes();
	void switchModeCpu();
	void switchModeGpu();
	void switchModeTime();

	void showMode() const;
	
	Manager(bool CPU, bool GPU, bool timeMeasure, int numbVectors = 10, int numbMatrices = 10);
	~Manager();
};