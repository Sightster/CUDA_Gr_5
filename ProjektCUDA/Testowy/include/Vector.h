#pragma once

#include <stdlib.h>
#include <time.h>
#include <iostream>

class Vector {
private:
	int _size;
	int* _ptr;
public:
	int getSize() const;
	int* getPtr() const;

	void fill(const int min = 0, const int max = 5); //fills vector with numbers in given range
	void print(const int x = 3) const; //shows vector, you can specify width of display field
	void show() const; //printf brief information about vector

	//calculations
	Vector& operator =(const Vector& v2);
	bool operator == (const Vector& v2) const;
	Vector operator + (const Vector& v2) const;
	Vector operator - (const Vector& v2) const;
	int operator * (const Vector& v2) const; //dot product


	//constructors
	Vector(const int size);
	Vector(const Vector& source);
	~Vector();
};