
#include <stdio.h>

main()
{
    unsigned int tmp = 0xBBAA9988U;
    int a;
    unsigned int b;
    a = ((long) ((char) (tmp & 0xFF)));
    b = ((long) ((char) (tmp & 0xFF)));
    printf("%d 0x%08X\n", a, b);
    exit(0);
}

