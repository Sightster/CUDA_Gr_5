#include "VWorkspace.h"
//vWorkspace

void vWorkspace::intInput(int* input)const {
	std::cin >> *input;
	while (std::cin.fail()) {
		std::cout << "Enter integer number: \n";
		std::cin.clear();
		std::cin.ignore(100, '\n');
		std::cin >> *input;
	}
}

bool vWorkspace::inputPosition(int* position1) const {
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

Vector* vWorkspace::createVector() {
	int position, size;
	std::cout << "In which position: ";
	intInput(&position);
	
	if (position >= _size || position < 0) {
		std::cout << "Invalid position choose number in range: 0 - " << _size - 1 << '\n';
		return nullptr;
	}
	if (_ptr[position] != nullptr) {
		bool replace;
		std::cout << "Given position is already taken!\n" << "Do you want replace vector nr " << position << "?\n"
			<< "Press: 0)No     1)Yes\n";
		std::cin >> replace;
		if(replace == 0)
			return _ptr[position];
	}

	std::cout << "Enter size of new vector: ";
	intInput(&size);
	delete _ptr[position];
	_ptr[position] = new Vector(size);
	if (_ptr[position] == nullptr)
		std::cout << "Memory alocation failed\n";
	else
		std::cout << "New vector created successfully\n";
	return _ptr[position];
}

void vWorkspace::deleteVector() {
	int position;
	std::cout << "Which vector do you want to delete: ";
	intInput(&position);
	if (position >= _size || position < 0) {
		std::cout << "Invalid position choose number in range: 0 - " << _size - 1 << '\n';
		return;
	}
	delete _ptr[position];
	_ptr[position] = nullptr;
	std::cout << "Vector deleted successfully.\n";
}

void vWorkspace::fillRandom(){
	int min, max, position;
	std::cout << "Which vector do you want to fill: ";
	if (!inputPosition(&position))
		return;

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

void vWorkspace::show() const{
	std::cout << "Actual state of vWorkspace:\n";
	for (int i = 0; i < _size; i++) {
		std::cout << "Position " << i << ": ";
		if (_ptr[i] == nullptr) {
			std::cout << "Empty\n";
		}
		else {
			_ptr[i]->show();
		}
	}
}

void vWorkspace::printVector() const {
	int position;
	std::cout << "Which vector: ";
	std::cin >> position;
	if (position >= _size || position < 0) {
		std::cout << "Invalid position choose number in range: 0 - " << _size - 1 << '\n';
		return;
	}

	std::cout << "Vector nr " << position << ": ";
	if (_ptr[position] == nullptr) {
		std::cout << "Empty\n";
		return;
	}
	_ptr[position]->print();
}

void vWorkspace::compareVectors() const {
	int position1, position2;
	std::cout << "Which vector do you want to compare: ";
	if (!inputPosition(&position1))
		return;

	std::cout << "With which vector: ";
	if (!inputPosition(&position2))
		return;

	if ((*_ptr[position1]) == (*_ptr[position2]))
		std::cout << "Vector " << position1 << " and vector " << position2 << " are equal.\n";
	else
		std::cout << "Vector " << position1 << " and vector " << position2 << " are different.\n";
}

void vWorkspace::addVectors(bool cpu, bool gpu, bool timeMeasure) const {
	int position1, position2, position3, position4;
	std::cout << "Which vector do you want to add: ";
	if(!inputPosition(&position1))
		return;

	std::cout << "With which vector: ";
	if(!inputPosition(&position2))
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
		if (timeMeasure) {

		}
		_ptr[position3] = new Vector(_ptr[position2]->getSize());
		*_ptr[position3] = *_ptr[position1] + *_ptr[position2];
		if (timeMeasure) {

		}
	}
	
	if (gpu) {
		if (timeMeasure) {

		}

		if (timeMeasure) {

		}
	}
}

void vWorkspace::substractVectors(bool cpu, bool gpu, bool timeMeasure) const {
	int position1, position2, position3, position4;
	std::cout << "Which vector do you want to aubstract: ";
	if (!inputPosition(&position1))
		return;

	std::cout << "With which vector: ";
	if (!inputPosition(&position2))
		return;

	if(cpu){
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
		if (timeMeasure) {

		}
		_ptr[position3] = new Vector(_ptr[position2]->getSize());
		*_ptr[position3] = *_ptr[position1] - *_ptr[position2];
		if (timeMeasure) {

		}
	}
	
	if (gpu) {
		if (timeMeasure) {

		}

		if (timeMeasure) {

		}

	}
}

void vWorkspace::dotProductVectors(bool cpu, bool gpu, bool timeMeasure) const {
	int position1, position2;
	std::cout << "Which vector do you want to dot product: ";
	if (!inputPosition(&position1))
		return;

	std::cout << "With which vector: ";
	if (!inputPosition(&position2))
		return;

	if (cpu) {
		if (timeMeasure) {

		}
		std::cout << "Dot product = "<< *_ptr[position1] * *_ptr[position2];
		if (timeMeasure) {

		}
	}

	if (gpu) {
		if (timeMeasure) {

		}
		//std::cout << "Dot product = " << *_ptr[position1] * *_ptr[position2];
		if (timeMeasure) {

		}
	}
	
}

vWorkspace::vWorkspace(int size):
	_size(size),
	_ptr(new Vector*[size])
	{
	for (int i = 0; i < size; i++) {
		_ptr[i] = nullptr;
	}
}

vWorkspace::~vWorkspace() {
	for (int i = 0; i < _size; i++) {
		delete _ptr[i];
	}
	delete[] _ptr;
}

