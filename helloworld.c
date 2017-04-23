__global__ void mykernel(void) {
}
int main() {
	mykernel<<<1,1>>>();
	printf("Hi");
	return 0;
}

