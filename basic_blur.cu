#include <stdlib.h>
#include <stdio.h>

__global__ void blur(float *A, float *B, int n)
{
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < n && col < n)
    {
        float presum = 0;
        for (int i = row - 1; i <= row + 1; i++)
        {
            for (int j = col - 1; j <= col + 1; j++)
            {
                presum += A[i * n + j];
            }
        }
        B[row * n + col] = presum / 9;
    }
}