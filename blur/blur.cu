#include <stdlib.h>
#include <stdio.h>
#include "blur.h"

#define BLUR_SIZE 1

__global__ void blur(unsigned char *in, unsigned char *out, int w, int h)
{
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < h && col < w)
    {
        int pixVal = 0, pixels = 0;
        for (int blurRow = -BLUR_SIZE; blurRow < BLUR_SIZE + 1; ++blurRow)
        {
            for (int blurCol = -BLUR_SIZE; bulrCol < BLUR_SIZE + 1; ++blurCol)
            {
                int curRow = row + blurRow;
                int curCol = col + blurCol;
                if (curRow >= 0 && curRow < h && curCol >= 0 && curCol < w)
                {
                    pixVal += in[curRow * w + curCol];
                    ++pixels;
                }
            }
        }
        out[row * w + col] = (unsigned char)((float)pixVal / pixels);
    }
}

void blurImage()
{
    char *in_d, *out_d;
    int w, h

               cudaMalloc((void **)&in_d, size);
    cudaMalloc((void **)&out, size);

    cudaMemcpy(in_d, in_h, size, cudaMemcpyHostToDevice);
    cudaMemcpy(out_d, out_h, size, cudaMemcpyHostToDevice);

    dim3 dimBlock(32, 16);
    dim3 dimGrid(ceil(n / 32.0), ceil(n / 16.0));

    blur<<<dimGrid, dimBlock>>>(in_d, out_d, w, h);

    cudaMemcpy(out_h, out_d, size, cudaMemcpyDeviceToHost);

    printf("%f\n", C_h[0]);

    cudaFree(in_d);
    cudaFree(out_d);

    free(in_h);
    free(out_h);
}