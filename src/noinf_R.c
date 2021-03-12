#include <math.h>
//#include <stdio.h>

void C_noinf(double *weight, int* status, double* prob, int *n, int *times, double *err)
{
    int i, j, k;
    
    for (k = 0; k < *times; k++) {
        for (i = 0; i < *n; i++) {
            for (j = 0; j < *n; j++) {
                err[k] += weight[k*(*n)+i] * (status[k*(*n)+i] - prob[k*(*n)+j]) * (status[k*(*n)+i] - prob[k*(*n)+j]);
            }
        }
    }
    
    for (k = 0; k < *times; k++) err[k] /= (*n)*(*n);
}
