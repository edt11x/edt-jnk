
#include <stdio.h>

main()
{
int a[3];

    a[0]   = 1;
    *(a+1) = 2;
    a[2]   = 3;

    printf("%d %d %d\n", *(a+0), 1[a], a[2]);
    exit(0);
}
