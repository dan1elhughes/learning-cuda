#include <stdio.h>

__global__ void add(int *a, int *b, int *c) {
	*c = *a + *b;
}

int main(void) {
    int a, b, c; // host copies of a, b, c
    int *gpu_a, *gpu_b, *gpu_c; // device copies of a, b, c
    int size = sizeof(int);

    // Allocate space for device copies of a, b, c
    cudaMalloc((void **) &gpu_a, size);
    cudaMalloc((void **) &gpu_b, size);
    cudaMalloc((void **) &gpu_c, size);

    // Setup input values
    a = 2;
    b = 7;

    // Copy inputs to device
    cudaMemcpy(gpu_a, &a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(gpu_b, &b, size, cudaMemcpyHostToDevice);

    // Launch add() kernel on GPU
    add <<<1, 1>>> (gpu_a, gpu_b, gpu_c);

    // Copy result back to host
    cudaMemcpy(&c, gpu_c, size, cudaMemcpyDeviceToHost);

    // Cleanup
    cudaFree(gpu_a);
    cudaFree(gpu_b);
    cudaFree(gpu_c);
    printf("%i", c);
    return 0;
}
