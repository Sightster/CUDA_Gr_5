#include "Vector.h"


int Vector::getSize() const {
	return _size;
}

int* Vector::getPtr() const {
	return _ptr;
}

Vector& Vector::operator =(const Vector& source){
	_size = source._size;
	_ptr = new int[_size];
	for (int i = 0; i < _size; i++) {
		_ptr[i] = source._ptr[i];
	}
	return *this;
}

bool Vector::operator == (const Vector& v2) const {
	if (_size != v2._size)
		return false;
	for (int i = 0; i < _size; i++)
		if (_ptr[i] != v2._ptr[i])
			return false;
	return true;
}

Vector Vector::operator + (const Vector& v2) const {
	if (_size != v2._size) {
		std::cout << "Adding failed sizes of vectors doesn't match\n";
		Vector result(0);
		return result;
	}
	Vector result(_size);
	for (int i = 0; i < _size; i++)
		result._ptr[i] = _ptr[i] + v2._ptr[i];
	return result;
}

Vector Vector::operator - (const Vector& v2) const {
	if (_size != v2._size) {
		std::cout << "Substracting failed sizes of vectors doesn't match\n";
		Vector result(0);
		return result;
	}
	Vector result(_size);
	for (int i = 0; i < _size; i++)
		result._ptr[i] = _ptr[i] - v2._ptr[i];
	return result;
}

int Vector::operator * (const Vector& v2) const {
	int product = 0;
	if (_size != v2._size) {
		std::cout << "Dot product failed sizes of vectors doesn't match\n";
		return product;
	}
	for (int i = 0; i < _size; i++)
		product = product + _ptr[i] * v2._ptr[i];
	return product;
}

void Vector::fill(const int min, const int max) {
	for (int i = 0; i < _size; i++)
		_ptr[i] = rand() % (max - min + 1) + min;
}

void Vector::print(const int width) const {
	for (int i = 0; i < _size; i++)
		printf("%*.d ",width , _ptr[i]);
	putchar('\n');
}

void Vector::show() const {
	std::cout << "Vector size: " << _size << '\n';
}

Vector::Vector(const int size) :
	_size(size),
	_ptr(new int[size])
{
	for (int i = 0; i < _size; i++)
		_ptr[i] = 1;
}

Vector::Vector(const Vector& source) {
	_size = source._size;
	_ptr = new int[_size];
	for (int i = 0; i < _size; i++) {
		_ptr[i] = source._ptr[i];
	}
}

Vector::~Vector() {
	delete[] _ptr;
}