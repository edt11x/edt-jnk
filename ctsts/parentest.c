
#include <stdio.h>

main()
{
int a[20];
int b[20];
int *c = a;
int *d = b;
int i = 0;

    for (i = 0; i < 20; i++)
    {
        /* does the parenthesis cause the ++ to evaluate early? */
        (*d++) = (*c++) = i;
    }
    for (i = 0; i < 20; i++)
    {
        printf("i %d, a[i] %d, b[i] %d\n", i, a[i], b[i]);
    }
}
