
#include <stdio.h>
#include <stdlib.h>

typedef int(intFunc)(int);

int printme(int a)
{
    return printf("This is %d\n", a);
}

main()
{
int (*b)(int) = &printme;
intFunc * c = &printme;

    (*b)(3);
    (*b)(4);
    exit(0);
}
