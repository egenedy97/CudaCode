#include <stdio.h>
#include <bits/stdc++.h>

#define N (2048*2048)
#define THREADS_PER_BLOCK 512
__global__ void add(int *a, int *b, int *c, int n) {
   int index = threadIdx.x+ blockIdx.x* blockDim.x;
   if (index < n)c[index] = a[index] + b[index];
}

void random_ints ( int *a, int N)
{
   int i;
   for (i = 0; i < N; ++i)
    a[i] = rand();
}

int main(void) 
{
   int*a, *b, *c;
   // host copies of a, b, c
   int*d_a, *d_b, *d_c;
   // device copies of a, b, c
   int size = N * sizeof(int);
   // Allocspace for device copies of a, b, c
   cudaMalloc((void**)&d_a, size);
   cudaMalloc((void**)&d_b, size);
   cudaMalloc((void**)&d_c, size);
   // Allocspace for host copies of a, b, c and setup input values
   a = (int*)malloc(size);
   random_ints(a, N);
   b = (int*)malloc(size); 
   random_ints(b, N);
   c = (int*)malloc(size);
   cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
   cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);
   add<<<N/THREADS_PER_BLOCK,THREADS_PER_BLOCK>>>(d_a, d_b, d_c);
   cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);
   free(a); free(b); free(c);
   cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
   return 0;
}