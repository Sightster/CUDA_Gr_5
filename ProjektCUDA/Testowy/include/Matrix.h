#pragma once

#include <stdlib.h>
#include <time.h>
#include <iostream>

class Matrix {
private:
	int _row;
	int _col;
	int* _ptr;

public:
	int getRow() const;
	int getCol() const;
	int* getPtr() const;

	void fill(int min = 0, int max = 5);//fills matrix with randome numbers in given range
	void print(int width = 3) const; //shows matrix you can specify width of dispaly field 
	void show() const;
	
	Matrix& operator =(const Matrix& source);
	bool operator == (const Matrix& m2) const;
	Matrix operator + (const Matrix& m2) const;
	Matrix operator - (const Matrix& m2) const;
	Matrix operator * (const Matrix& m2) const; //matrix multiplication

	//constructors
	Matrix(int row, int col);
	Matrix(const Matrix& source);
	~Matrix();
};