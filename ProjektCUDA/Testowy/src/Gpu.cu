#include "Gpu.h"

void Gpu::changeSizes() {
    do {
        std::cout << "Enter grid size:\n";
        std::cin.clear();
        std::cin.ignore(100, '\n');
        std::cin >> _gridSize;
    } while (std::cin.fail());

    do {
        std::cout << "Enter block size:\n";
        std::cin.clear();
        std::cin.ignore(100, '\n');
        std::cin >> _blockSize;
    } while (std::cin.fail());
}

int Gpu::getGrid() {
    return _gridSize;
}

int Gpu::getBlock() {
    return _blockSize;
}

Gpu::Gpu() {
    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, 0);
    printf("  Device name: %s\n", prop.name);
    printf("  Memory Clock Rate (KHz): %d\n",
        prop.memoryClockRate);
    printf("  Memory Bus Width (bits): %d\n",
        prop.memoryBusWidth);
    _gridSize = prop.multiProcessorCount;
    _blockSize = prop.maxThreadsPerBlock;
    printf("  Multi Processor Count : %d\n",
        _gridSize);
    printf("  Max threads per block : %d\n\n",
        _blockSize);
    
}