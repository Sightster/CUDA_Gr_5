#include"MWorkspace.h"

void mWorkspace::intInput(int* input)const {
	std::cin >> *input;
	while (std::cin.fail()) {
		std::cout << "Enter integer number: \n";
		std::cin.clear();
		std::cin.ignore(100, '\n');
		std::cin >> *input;
	}
}

bool mWorkspace::inputPosition(int* position1) const {
	intInput(position1);
	if (*position1 >= _size || *position1 < 0) {
		std::cout << "Invalid position choose number in range: 0 - " << _size - 1 << '\n';
		return false;
	}
	if (_ptr[*position1] == nullptr) {
		std::cout << "This position doesn't contain vector\n";
		return false;
	}
	return true;
}

Matrix* mWorkspace::createMatrix() {
	int position, row, col;
	std::cout << "In which position: ";
	intInput(&position);
	std::cout << "How many rows new matrix has: ";
	intInput(&row);
	std::cout << "How many columns new matrix has: ";
	intInput(&col);

	if (position >= _size || position < 0) {
		std::cout << "Invalid position choose number in range: 0 - " << _size - 1 << '\n';
		return nullptr;
	}

	if (_ptr[position] != nullptr) {
		bool replace;
		std::cout << "Given position is already taken!\n" << "Do you want replace matrix nr " << position << "?\n"
			<< "Press: 0)No     1)Yes";
		std::cin >> replace;
		if (replace == 0)
			return _ptr[position];
	}
	delete _ptr[position];

	_ptr[position] = new Matrix(row, col);
	if (_ptr[position] == nullptr)
		std::cout << "Memory alocation failed\n";
	else
		std::cout << "New matrix created successfully\n";
	_ptr[position]->fill(1, 5);
	return _ptr[position];
}

void mWorkspace::deleteMatrix() {
	int position;
	std::cout << "Which matrix do you want to delete: ";
	intInput(&position);
	if (position >= _size || position < 0) {
		std::cout << "Invalid position choose number in range: 0 - " << _size - 1 << '\n';
		return;
	}
	delete _ptr[position];
	_ptr[position] = nullptr;
	std::cout << "Matrix deleted successfully.\n";
}

void mWorkspace::fillRandom() {
	int min, max, position;
	std::cout << "Which matrix do you want to fill: ";
	intInput(&position);
	if (position >= _size || position < 0) {
		std::cout << "Invalid position choose number in range: 0 - " << _size - 1 << '\n';
		return;
	}
	if (_ptr[position] == nullptr) {
		std::cout << "This position doesn't contain matrix\n";
		return;
	}

	std::cout << "Provide bottom limit: ";
	intInput(&min);
	std::cout << "Provide upper limit: ";
	intInput(&max);
	if (min > max) {
		std::cout << "Upper limit should be greater than bottom one!\n";
		return;
	}

	_ptr[position]->fill(min, max);
}

void mWorkspace::show() const {
	std::cout << "Actual state of mWorkspace:\n";
	for (int i = 0; i < _size; i++) {
		std::cout << "Postion " << i << ": ";
		if (_ptr[i] == nullptr) {
			std::cout << "Empty\n";
		}
		else {
			_ptr[i]->show();
		}
	}
}

void mWorkspace::printMatrix() const {
	int position;
	std::cout << "In which position: ";
	intInput(&position);
	if (position >= _size || position < 0) {
		std::cout << "Invalid position choose number in range: 0 - " << _size - 1 << '\n';
		return;
	}

	std::cout << "Matrix nr " << position << ": \n";
	if (_ptr[position] == nullptr) {
		std::cout << "Empty\n";
		return;
	}
	_ptr[position]->print();
}

void mWorkspace::compareMatrices() const {
	int position1, position2;
	std::cout << "Which matrix do you want to compare: ";
	if (!inputPosition(&position1))
		return;

	std::cout << "Witch which matrix: ";
	if (!inputPosition(&position2))
		return;

	if ((*_ptr[position1]) == (*_ptr[position2]))
		std::cout << "Matrix " << position1 << " and matrix " << position2 << " are equal.\n";
	else
		std::cout << "Matrix " << position1 << " and matrix " << position2 << " are different.\n";
}

void mWorkspace::addMatrices(bool cpu, bool gpu, bool timeMeasure) const {
	int position1, position2, position3, position4;
	std::cout << "Which matrix do you want to add: ";
	if (!inputPosition(&position1))
		return;

	std::cout << "With which matrix: ";
	if (!inputPosition(&position2))
		return;
	if (cpu) {
		std::cout << "Chose position in workspace where result will be save: ";
		intInput(&position3);

		if (position3 >= _size || position3 < 0) {
			std::cout << "Invalid position choose number in range: 0 - " << _size - 1 << '\n';
			return;
		}
		if (_ptr[position3] != nullptr) {
			std::cout << "Given position is already taken!\n";
			return;
		}
	}

	if (gpu) {
		std::cout << "Chose position in workspace where result from GPU will be save: ";
		intInput(&position4);

		if (position4 >= _size || position4 < 0) {
			std::cout << "Invalid position choose number in range: 0 - " << _size - 1 << '\n';
			return;
		}
		if (_ptr[position4] != nullptr) {
			std::cout << "Given position is already taken!\n";
			return;
		}
	}

	if (cpu) {
		StopWatchInterface* timer;
		if (timeMeasure) {
			printf("Cpu computing...\n");
			timer = startTimer();
		}
		_ptr[position3] = new Matrix(_ptr[position2]->getRow(), _ptr[position1]->getCol());
		*_ptr[position3] = *_ptr[position1] + *_ptr[position2];
		if (timeMeasure) {
			printf("Computing ended\n");
			stopTimer(timer);
			putchar('\n');
		}
	}

	if (gpu) {
		StopWatchInterface* timer;
		if (timeMeasure) {
			printf("Gpu computing...\n");
			timer = startTimer();
		}
		_ptr[position4] = new Matrix(_ptr[position2]->getRow(), _ptr[position1]->getCol());
		addGpu(_GPU, _ptr[position1]->getPtr(), _ptr[position2]->getPtr(), _ptr[position4]->getPtr(),
			_ptr[position1]->getRow() * _ptr[position1]->getCol());
		if (timeMeasure) {
			printf("Computing ended\n");
			stopTimer(timer);
			putchar('\n');
		}
	}

	if (gpu && cpu) {
		if (*_ptr[position4] == *_ptr[position3])
			printf("Results match!\n");
		else
			printf("Results does not match!\n");
	}
}

void mWorkspace::substractMatrices(bool cpu, bool gpu, bool timeMeasure) const {
	int position1, position2, position3, position4;
	std::cout << "Which matrix do you want to substract: ";
	if (!inputPosition(&position1))
		return;

	std::cout << "With which matrix: ";
	if (!inputPosition(&position2))
		return;
	if (cpu) {
		std::cout << "Chose position in workspace where result will be save: ";
		intInput(&position3);

		if (position3 >= _size || position3 < 0) {
			std::cout << "Invalid position choose number in range: 0 - " << _size - 1 << '\n';
			return;
		}
		if (_ptr[position3] != nullptr) {
			std::cout << "Given position is already taken!\n";
			return;
		}
	}

	if (gpu) {
		std::cout << "Chose position in workspace where result from GPU will be save: ";
		intInput(&position4);

		if (position4 >= _size || position4 < 0) {
			std::cout << "Invalid position choose number in range: 0 - " << _size - 1 << '\n';
			return;
		}
		if (_ptr[position4] != nullptr) {
			std::cout << "Given position is already taken!\n";
			return;
		}
	}

	if (cpu) {
		StopWatchInterface* timer;
		if (timeMeasure) {
			printf("Cpu computing...\n");
			timer = startTimer();
		}
		_ptr[position3] = new Matrix(_ptr[position2]->getRow(), _ptr[position1]->getCol());
		*_ptr[position3] = *_ptr[position1] - *_ptr[position2];
		if (timeMeasure) {
			printf("Computing ended\n");
			stopTimer(timer);
			putchar('\n');
		}
	}

	if (gpu) {
		StopWatchInterface* timer;
		if (timeMeasure) {
			printf("Gpu computing...\n");
			timer = startTimer();
		}
		_ptr[position4] = new Matrix(_ptr[position2]->getRow(), _ptr[position1]->getCol());
		subGpu(_GPU, _ptr[position1]->getPtr(), _ptr[position2]->getPtr(), _ptr[position4]->getPtr(),
			_ptr[position1]->getRow() * _ptr[position1]->getCol());
		if (timeMeasure) {
			printf("Computing ended\n");
			stopTimer(timer);
			putchar('\n');
		}
	}

	if (gpu && cpu) {
		if (*_ptr[position4] == *_ptr[position3])
			printf("Results match!\n");
		else
			printf("Results does not match!\n");
	}
}


void mWorkspace::multiplyMatrices(bool cpu, bool gpu, bool timeMeasure) const {
	int position1, position2, position3, position4;
	std::cout << "Which matrix do you want to multiply: ";
	if (!inputPosition(&position1))
		return;

	std::cout << "With which matrix: ";
	if (!inputPosition(&position2))
		return;
	if (cpu) {
		std::cout << "Chose position in workspace where result will be save: ";
		intInput(&position3);

		if (position3 >= _size || position3 < 0) {
			std::cout << "Invalid position choose number in range: 0 - " << _size - 1 << '\n';
			return;
		}
		if (_ptr[position3] != nullptr) {
			std::cout << "Given position is already taken!\n";
			return;
		}
	}

	if (gpu) {
		std::cout << "Chose position in workspace where result from GPU will be save: ";
		intInput(&position4);

		if (position4 >= _size || position4 < 0) {
			std::cout << "Invalid position choose number in range: 0 - " << _size - 1 << '\n';
			return;
		}
		if (_ptr[position4] != nullptr) {
			std::cout << "Given position is already taken!\n";
			return;
		}
	}

	if (cpu) {
		StopWatchInterface* timer;
		if (timeMeasure) {
			printf("Cpu computing...\n");
			timer = startTimer();
		}
		_ptr[position3] = new Matrix(_ptr[position1]->getCol(), _ptr[position2]->getRow());
		*_ptr[position3] = *_ptr[position1] * *_ptr[position2];
		if (timeMeasure) {
			printf("Computing ended\n");
			stopTimer(timer);
			putchar('\n');
		}
	}

	if (gpu) {
		StopWatchInterface* timer;
		if (timeMeasure) {
			printf("Cpu computing...\n");
			timer = startTimer();
		}
		_ptr[position4] = new Matrix(_ptr[position1]->getRow(), _ptr[position2]->getCol());
		mulGpu(_GPU, _ptr[position1]->getPtr(), _ptr[position2]->getPtr(), _ptr[position4]->getPtr(),
			_ptr[position1]->getRow(), _ptr[position1]->getCol(), _ptr[position2]->getCol());
		if (timeMeasure) {
			printf("Computing ended\n");
			stopTimer(timer);
			putchar('\n');
		}
	}

	if (gpu && cpu) {
		if (*_ptr[position4] == *_ptr[position3])
			printf("Results match!\n");
		else
			printf("Results does not match!\n");
	}
}

void mWorkspace::invertMatrices(bool cpu, bool gpu, bool timeMeasure) const {

}

mWorkspace::mWorkspace(int size, Gpu* gpu) :
	_size(size),
	_ptr(new Matrix* [size]),
	_GPU(gpu)
{
	for (int i = 0; i < size; i++) {
		_ptr[i] = nullptr;
	}
}

mWorkspace::~mWorkspace() {
	for (int i = 0; i < _size; i++) {
		delete _ptr[i];
	}
	delete[] _ptr;
}