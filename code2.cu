#include <stdio.h>
#include <bits/stdc++.h>
__global__ void add(int*a, int*b, int*c) {*c = *a + *b;}

int main(void) {
    int a, b, c;// host copies of a, b, c
    int*d_a, *d_b, *d_c;// device copies of a, b, c
    int size = sizeof(int);// Allocate space for device copies of a, b, c
    cudaMalloc((void**)&d_a, size);
    cudaMalloc((void**)&d_b, size);
    cudaMalloc((void**)&d_c, size);// Setup input values
    a = 2;
    b = 5;
    cudaMemcpy(d_a, &a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, &b, size, cudaMemcpyHostToDevice);
    add<<<1,1>>>(d_a, d_b, d_c);
    cudaMemcpy(&c, d_c, size, cudaMemcpyDeviceToHost);
    printf("%d\n%d\n%d\n" , c, a,b );
    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
    return 0 ; 
}
