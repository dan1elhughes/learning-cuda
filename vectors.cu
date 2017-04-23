#include <stdio.h>
#include <stdlib.h>

__global__ void vector_add(int *a, int *b, int *c) {
	c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}

void random_ints(int* a, int n) {
	int i;
	for (i = 0; i < n; ++i) {
		a[i] = rand();
	}
}

int getRand() {
	// return rand() % 50;

	// Chosen by a fair dice roll; guaranteed to be random.
	return 1;
}

int main(void) {
	int vector1[8];
	int vector2[8];
	int vector_out[8];

	int *gpu_vector1, *gpu_vector2, *gpu_vector_out;

	int size = sizeof(int) * 8;

	// Allocate space for device copies of a, b, c
	 cudaMalloc((void **) &gpu_vector1, size);
	 cudaMalloc((void **) &gpu_vector2, size);
	 cudaMalloc((void **) &gpu_vector_out, size);

	 // Populate the input vectors with random integers
	 random_ints(vector1, 8);
	 random_ints(vector2, 8);

	 for(int i = 0; i < 8; i++) {
		 printf("%d\t", vector1[i]);
	 }
	 printf("\n");

	 for(int i = 0; i < 8; i++) {
		 printf("%d\t", vector2[i]);
	 }
	 printf("\n\n");

	// Copy inputs to device
	 cudaMemcpy(gpu_vector1, &vector1, size, cudaMemcpyHostToDevice);
	 cudaMemcpy(gpu_vector2, &vector2, size, cudaMemcpyHostToDevice);

	// Launch vector_add() kernel on GPU
	 vector_add <<<8, 1>>> (gpu_vector1, gpu_vector2, gpu_vector_out);

	// Copy result back to host
	 cudaMemcpy(&vector_out, gpu_vector_out, size, cudaMemcpyDeviceToHost);

	// Cleanup
	 cudaFree(gpu_vector1);
	 cudaFree(gpu_vector2);
	 cudaFree(gpu_vector_out);

	for(int i = 0; i < 8; i++) {
		printf("%d\t", vector_out[i]);
	 }
	 printf("\n");

	 return 0;
}
