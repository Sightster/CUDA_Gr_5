#include "Matrix.h"


int Matrix::getRow() const {
	return _row;
}

int Matrix::getCol() const {
	return _col;
}

int* Matrix::getPtr() const {
	return _ptr;
}

Matrix& Matrix::operator =(const Matrix& source) {
	_row = source._row;
	_col = source._col;
	int size = _row * _col;
	_ptr = new int[size];
	for (int i = 0; i < size; i++) {
		_ptr[i] = source._ptr[i];
	}
	return *this;
}

bool Matrix::operator == (const Matrix& m2) const {
	if (_row != m2._row || _col != m2._col)
		return false;
	for (int i = 0; i < _row * _col; i++)
		if (_ptr[i] != m2._ptr[i])
			return false;
	return true;
}

Matrix Matrix::operator + (const Matrix& m2) const {
	if (_row != m2._row || _col != m2._col) {
		std::cout << "Adding failed dimensions of Matirx doesn't match\n";
		Matrix result(0, 0);
		return result;
	}
	int size = _row * _col;
	Matrix result(_row, _col);
	for (int i = 0; i < size; i++)
		result._ptr[i] = _ptr[i] + m2._ptr[i];
	return result;
}

Matrix Matrix::operator - (const Matrix& m2) const {
	if (_row != m2._row || _col != m2._col) {
		std::cout << "Substracting failed dimensions of Matirx doesn't match\n";
		Matrix result(0, 0);
		return result;
	}
	int size = _row * _col;
	Matrix result(_row, _col);
	for (int i = 0; i < size; i++)
		result._ptr[i] = _ptr[i] - m2._ptr[i];
	return result;
}

Matrix Matrix::operator * (const Matrix& m2) const {
	if (_col != m2._row) {
		std::cout << "Wymiary macierzy nie pasuja do siebie!\n";
		Matrix result(0, 0);
		return result;
	}
	Matrix result(_row, m2._col);
	int sum;
	for (int i = 0; i < _row; ++i)
		for (int j = 0; j < m2._col; ++j) {
			sum = 0;
			for (int k = 0; k < _col; ++k)
			{
				sum += _ptr[i * _col + k] * m2._ptr[k * m2._col + j];
			}
			(result.getPtr())[i * m2._col + j] = sum;
		}
	return result;
}

void Matrix::fill(int min, int max) {
	srand(unsigned int(time(NULL)));
	for (int i = 0; i < _row; i++) {
		for (int j = 0; j < _col; j++) {
			_ptr[i * _col + j] = rand() % (max - min + 1) + min;
		}
	}
}

void Matrix::print(int width) const {
	for (int i = 0; i < _row; i++) {
		for (int j = 0; j < _col; j++) {
			printf("%*.d ", width, _ptr[i * _col + j]);
		}
		putchar('\n');
	}
}

void Matrix::show() const {
	std::cout << "Matrix size: " << _row <<"x" <<_col << '\n';
}

Matrix::Matrix(int row, int col): 
_row(row),
_col(col)
{
	int size = row * col;
	int* ptr = new int[size];
	_ptr = ptr;
}

Matrix::Matrix(const Matrix& source) {
	_row = source._row;
	_col = source._col;
	int size = _row * _col;
	_ptr = new int[size];
	for (int i = 0; i < size; i++) {
		_ptr[i] = source._ptr[i];
	}
}

Matrix::~Matrix() {
	delete[] _ptr;
}