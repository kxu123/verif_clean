import sys
import math

#precompute
def cordic_reference(x, y):
    cordic_angles = [180/3.14159*math.atan(2**(-i)) for i in range(17)]
    print(cordic_angles)
    # x = 34002
    # y = 1172
    z = 0

    # x = 1172
    # y = 34002

    #actual run-time:
    for i in range(16):
        if y >0: #sng(y)==1
            xn = x + 1/(2**i)*y
            yn = y - 1/(2**i)*x
            zn = z + cordic_angles[i]
        else:  #sng(y) == -1
            xn = x - 1/(2**i)*y
            yn = y + 1/(2**i)*x
            zn = z - cordic_angles[i]

        print(f"x:{xn}, y:{yn}, z:{zn}")
        x = xn
        y = yn
        z = zn

    print(x/1.646)
    print(z)

    return (x/1.646, z)

cordic_reference(1000, 1000)