// Testowy.cpp : Defines the entry point for the application.
//

#include "Main.h"


int main(int argc, int argv)
{
    bool cpu, gpu, timeMeasure;
    cpu = true;
    gpu = true;
    timeMeasure = true;
    int vectors, matrices;
    vectors = matrices = 5;

    std::cout << "Current program configuration:\n";
    std::cout << "CPU: " << (cpu ? "ON" : "OFF") << " | GPU: " << (gpu ? "ON" : "OFF")
        << " | Time measure: " << (timeMeasure ? "ON\n" : "OFF\n");
    std::cout << "Workspaces size Vectors: " << vectors << " Matrices: " << matrices << '\n';

    bool conf;
    std::cout << "Do you want change size of Workspaces? 0)No     1)Yes\n";
    std::cin >> conf;
    while (std::cin.fail()) {
        std::cout << "Enter 0 or 1 \n";
        std::cin.clear();
        std::cin.ignore(100, '\n');
        std::cin >> conf;
    }
    if (conf) {
        std::cout << "Enter number of vectors: ";
        std::cin >> vectors;
        std::cout << "Enter number of matrices: ";
        std::cin >> matrices;
    }
    
    Manager core(cpu, gpu, timeMeasure, vectors, matrices);
    core.mainMenu();
    
    return 0;
}


