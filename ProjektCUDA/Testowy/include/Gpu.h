#pragma once
#include <iostream>

class Gpu {
private:
	int _gridSize;
	int _blockSize;
public:
	void changeSizes();
	int getGrid();
	int getBlock();
	Gpu();
	
};