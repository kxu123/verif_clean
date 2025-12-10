#include <stdio.h>
#include <math.h>
#include "svdpi.h"

void cordic_reference (float x, float y, float* x_out, float* z_out) {
    printf("cordic_reference, original_x %f, original_y %f\n", x, y);
    float cordic_angles[] = {45.000038009906035, 26.565073615635743, 14.03625532384415, 
        7.125022367150729, 3.576337395800319, 1.7899121201201589, 0.895174466332599, 
        0.44761454894438807, 0.22381068941334004, 0.11190577158896844, 
        0.05595293915522952, 0.027976476247722235, 0.013988238957624998, 
        0.006994119583032999, 0.003497059804544062, 0.0017485299039004764, 
        0.0008742649521537938};

    float xn, yn, zn;
    float z = 0;
    int i;

    for (i = 0; i < 16; i++) {
        if (y > 0) {
            xn = x + 1/pow(2, i)*y;
            yn = y - 1/pow(2, i)*x;
            zn = z + cordic_angles[i];
        } else {
            xn = x - 1/pow(2, i)*y;
            yn = y + 1/pow(2, i)*x;
            zn = z - cordic_angles[i];
        }

        x = xn;
        y = yn;
        z = zn;
    }
    x = x/1.646;
    printf("x: %f, z: %f, size of x %d\n", x, z, sizeof(x));
    *x_out = x;
    *z_out = z;    
}
