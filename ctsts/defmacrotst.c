
#include <stdio.h>

#define sysProcMac(a) ((unsigned long *) 0xf1000000UL)

int
main()
{
    printf("Hi\n");
    printf("Function returns %08X\n", (unsigned int) sysProcMac());
    return 0;
}

