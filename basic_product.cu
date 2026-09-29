#include <stdlib.h>
#include <stdio.h>

__global__ void product(float *A, float *B, float *C, int n)
{
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < n && col < n)
    {
        float sum = 0;
        for (int k = 0; k < n; k++)
        {
            sum += A[row * n + k] * B[k * n + col];
        }
        C[row * n + col] = sum;
    }
}

int main(int argc, char *argv[])
{
    int n = 64;
    if (argc >= 2)
        n = atoi(argv[1]);

    size_t size = n * n * sizeof(float);

    float *A_h = (float *)malloc(size);
    float *B_h = (float *)malloc(size);
    float *C_h = (float *)malloc(size);

    for (int i = 0; i < n * n; i++)
    {
        A_h[i] = 1.0f;
        B_h[i] = 1.0f;
    }

    float *A_d, *B_d, *C_d;

    cudaMalloc((void **)&A_d, size);
    cudaMalloc((void **)&B_d, size);
    cudaMalloc((void **)&C_d, size);

    cudaMemcpy(A_d, A_h, size, cudaMemcpyHostToDevice);
    cudaMemcpy(B_d, B_h, size, cudaMemcpyHostToDevice);

    dim3 dimBlock(32, 16);
    dim3 dimGrid(ceil(n / 32.0), ceil(n / 16.0));

    product<<<dimGrid, dimBlock>>>(A_d, B_d, C_d, n);

    cudaMemcpy(C_h, C_d, size, cudaMemcpyDeviceToHost);

    printf("%f\n", C_h[0]);

    cudaFree(A_d);
    cudaFree(B_d);
    cudaFree(C_d);

    free(A_h);
    free(B_h);
    free(C_h);

    return 0;
}

// notion
// Memory set aside by cudaMalloc or malloc is 1D,
// so you can't use 2D indexing like A[row][col]