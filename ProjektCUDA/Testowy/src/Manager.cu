#include "Manager.h"

void Manager::mainMenu() {
    bool stay = true;
    do {
        std::cout << "***Main Menu***\n";
        int choice;
        std::cout << "0)Conf    1)Data Manage     2)Calculate Vectors     3)Calculate Matrices     4)Show     5)Quit\n";
        std::cin >> choice;
        while(std::cin.fail()) {
            std::cout << "Enter number\n";
            std::cin.clear();
            std::cin.ignore(100, '\n');
            std::cin >> choice;
        }
 
        switch (choice)
        {
        case 0:
            confMenu();
            break;

        case 1:
            dataMenu();
            break;

        case 2:
            calculateVectorsMenu();
            break;

        case 3:
            calculateMatricesMenu();
            break;

        case 4:
            showMenu();
            break;
        case 5:
            stay = false;
            break;

        default:
            std::cout << "Invalid input, choose again\n";
            std::cin.clear();
            std::cin.ignore(100, '\n');
            break;
        }
        std::cout << stay;
    } while (stay);
}

//Conf part
void Manager::confMenu() {
    bool stay = true;
    do {
        std::cout << "\n***Configuration Menu***\n";
        int choice;
        std::cout << "0)Switch Mode GPU    1)Switch Mode CPU     2)Switch Time Measure Mode     3)Show      4)Back\n";
            
        std::cin >> choice;
        while (std::cin.fail()) {
            std::cout << "Enter number\n";
            std::cin.clear();
            std::cin.ignore();
            std::cin >> choice;
        }

        switch (choice)
        {
        case 0:
            switchModeGpu();
            break;

        case 1:
            switchModeCpu();
            break;

        case 2:
            switchModeTime();
            break;
        case 3:
            showMenu();
            break;

        case 4:
            stay = false;
            break;

        default:
            std::cout << "Invalid input, choose again\n";
            std::cin.clear();
            std::cin.ignore(100, '\n');
            break;
        }

    } while (stay);
}

void Manager::switchModeCpu() {
    _cpu ^= true;
    showMode();
}

void Manager::switchModeGpu() {
    _gpu ^= true;
    showMode();
}

void Manager::switchModeTime() {
    _timeMeasure ^= true;
    showMode();
}


//show part
void Manager::showMenu() {
    bool stay = true;
    do {
        std::cout << "\n***Show Menu***\n";
        int choice;
        std::cout << "0)vWorkspace    1)mWorkspace     2)Print Vector     3)Print Matrix     4)Mode     5)Back\n";
        std::cin >> choice;
        while (std::cin.fail()) {
            std::cout << "Enter number\n";
            std::cin.clear();
            std::cin.ignore(100, '\n');
            std::cin >> choice;
        }

        switch (choice)
        {
        case 0:
            _vectors->show();
            break;

        case 1:
            _matrices->show();
            break;

        case 2:
            _vectors->printVector();
            break;

        case 3:
            _matrices->printMatrix();
            break;

        case 4:
            showMode();
            break;

        case 5:
            stay = false;
            break;

        default:
            std::cout << "Invalid input, choose again\n";
            std::cin.clear();
            std::cin.ignore(100, '\n');
            break;
        }

    } while (stay);
}


void Manager::showMode() const {
    std::cout << "Current mode CPU: " << (_cpu ? "ON" : "OFF") << " | GPU: " << (_gpu ? "ON" : "OFF")
        << " | Time measure: " << (_timeMeasure ? "ON" : "OFF") << '\n';
}


//data part
void Manager::dataMenu() {
    bool stay = true;
    do {
        std::cout << "\n***Data Managment Menu***\n";
        int choice;
        std::cout << "0)Create Vector    1)Create Matrix     2)Fill Vector Random    3)Fill Matrix Random\n" 
            << "4)Delete Vector     5)Delete Matrix     6)Show     7)Back\n";
        std::cin >> choice;
        while (std::cin.fail()) {
            std::cout << "Enter number\n";
            std::cin.clear();
            std::cin.ignore(100,'\n');
            std::cin >> choice;
        }

        switch (choice)
        {
        case 0:
            _vectors->createVector();
            break;

        case 1:
            _matrices->createMatrix();
            break;

        case 2:
            _vectors->fillRandom();
            break;

        case 3:
            _matrices->fillRandom();
            break;

        case 4:
            _vectors->deleteVector();
            break;

        case 5:
            _matrices->deleteMatrix();
            break;

        case 6:
            showMenu();
            break;

        case 7:
            stay = false;
            break;

        default:
            std::cout << "Invalid input, choose again\n";
            std::cin.clear();
            std::cin.ignore(100, '\n');
            break;
        }

    } while (stay);
}


//calculation part
void Manager::calculateVectorsMenu() {
    bool stay = true;
    do {
        std::cout << "\n***Calculate Menu Vectors***\n";
        int choice;
        std::cout << "0)Compare    1)Add     2)Substract     3)Dot Product     4)Show     5)Back\n";
        std::cin >> choice;
        while (std::cin.fail()) {
            std::cout << "Enter number\n";
            std::cin.clear();
            std::cin.ignore(100, '\n');
            std::cin >> choice;
        }

        switch (choice)
        {
        case 0:
            _vectors->compareVectors();
            break;

        case 1:
            _vectors->addVectors(_cpu, _gpu, _timeMeasure);
            break;

        case 2:
            _vectors->substractVectors(_cpu, _gpu, _timeMeasure);
            break;

        case 3:
            _vectors->dotProductVectors(_cpu, _gpu, _timeMeasure);
            break;

        case 4:
            showMenu();
            break;

        case 5:
            stay = false;
            break;

        default:
            std::cout << "Invalid input, choose again\n";
            std::cin.clear();
            std::cin.ignore(100, '\n');
            break;
        }

    } while (stay);
}


void Manager::calculateMatricesMenu() {
    bool stay = true;
    do {
        std::cout << "\n***Calculate Menu Matrices***\n";
        int choice;
        std::cout << "0)Compare    1)Add     2)Substract     3)Multiplication     4)Invers     5)Show     6)Back\n";
        std::cin >> choice;
        while (std::cin.fail()) {
            std::cout << "Enter number\n";
            std::cin.clear();
            std::cin.ignore(100, '\n');
            std::cin >> choice;
        }

        switch (choice)
        {
        case 0:
            _matrices->compareMatrices();
            break;

        case 1:
            _matrices->addMatrices(_cpu, _gpu, _timeMeasure);
            break;

        case 2:
            _matrices->substractMatrices(_cpu, _gpu, _timeMeasure);
            break;

        case 3:
            _matrices->multiplyMatrices(_cpu, _gpu, _timeMeasure);
            break;

        case 4:
            _matrices->invertMatrices(_cpu, _gpu, _timeMeasure);
            break;

        case 5:
            showMenu();
            break;

        case 6:
            stay = false;
            break;

        default:
            std::cout << "Invalid input, choose again\n";
            std::cin.clear();
            std::cin.ignore(100, '\n');
            break;
        }

    } while (stay);
}
//rest
vWorkspace* Manager::vectors() const {
    return _vectors;
}

mWorkspace* Manager::matrices() const {
    return _matrices;
}


Manager::Manager(bool CPU, bool GPU, bool timeMeasure,  int numbVectors, int numbMatrices ):
    _vectors(new vWorkspace(numbVectors)),
	_matrices(new mWorkspace(numbMatrices)),
	_cpu(CPU),
	_gpu(GPU),
    _timeMeasure(timeMeasure) {}


Manager::~Manager() {
	delete _vectors;
	delete _matrices;
}