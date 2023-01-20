
#include <stdio.h>

main()
{
    int a = 2;
    int * p = &a;

    printf("this is a %d\n", a);
    (*p)++;
    printf("this is a %d\n", a);
    *p++;
    printf("this is a %d\n", a);
}
