#include <stdio.h>

__global__ void MyKernel(void) {
	// Empty
}

int main() {
	MyKernel<<<1,1>>>();
	printf("Hi");
	return 0;
}
