
#include <stdio.h>

main()
{
    unsigned char a[] = { 0x12, 0x34, 0x56, 0x78, 0x9a, 0xbc, 0xde };
    unsigned long *b = (unsigned long *) &a[0];

    printf("%02x\n", (*b & 0xff));
    printf("%02x\n", (*b  >> 24) & 0xff);
}
