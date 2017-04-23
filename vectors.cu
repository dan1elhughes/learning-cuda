#include <stdio.h>
#include <stdlib.h>

#define BLOCKS 4
#define THREADSPERBLOCK 4
#define VECSIZE 16

__global__ void vector_add(int *a, int *b, int *c) {
	int i = (blockIdx.x * THREADSPERBLOCK) + threadIdx.x;
	c[i] = a[i] + b[i];
}

void random_ints(int* a, int n) {
	int i;
	for (i = 0; i < n; ++i) {
		a[i] = rand() % n;
	}
}

void show_vector(int* vec, int size) {
	for(int i = 0; i < size; i++) {
		printf("%d\t", vec[i]);
	}
	printf("\n");
}

int main(void) {
	int vector1[VECSIZE];
	int vector2[VECSIZE];
	int vector_out[VECSIZE];

	int *gpu_vector1, *gpu_vector2, *gpu_vector_out;

	int size = sizeof(int) * VECSIZE;

	// Allocate space for device copies of a, b, c
	cudaMalloc((void **) &gpu_vector1, size);
	cudaMalloc((void **) &gpu_vector2, size);
	cudaMalloc((void **) &gpu_vector_out, size);

	// Populate the input vectors with random integers
	random_ints(vector1, VECSIZE);
	random_ints(vector2, VECSIZE);

	// Copy inputs to device
	cudaMemcpy(gpu_vector1, &vector1, size, cudaMemcpyHostToDevice);
	cudaMemcpy(gpu_vector2, &vector2, size, cudaMemcpyHostToDevice);

	vector_add<<<BLOCKS, THREADSPERBLOCK>>> (gpu_vector1, gpu_vector2, gpu_vector_out);

	// Copy result back to host
	cudaMemcpy(&vector_out, gpu_vector_out, size, cudaMemcpyDeviceToHost);

	// Cleanup
	cudaFree(gpu_vector1);
	cudaFree(gpu_vector2);
	cudaFree(gpu_vector_out);

	show_vector(vector1, VECSIZE);
	show_vector(vector2, VECSIZE);
	printf("\n");
	show_vector(vector_out, VECSIZE);

	printf("\n");

	return 0;
}
