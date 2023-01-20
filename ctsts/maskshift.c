
#include <stdio.h>

main()
{
unsigned int mask = 0xFF;
unsigned int shift = 0;

for (shift = 0; shift < 32; shift += 8)
{
    mask = 0xFF << shift;
    printf("%08X\n", mask);
}
printf("Last %08X\n", mask);
exit(0);
}

