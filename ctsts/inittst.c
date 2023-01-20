
#include <stdio.h>


main()
{
    char s[30] = "1\0";
    int i;

    for (i = 0; i < 30; i++)
    {
        printf("%d ", (int) s[i]);
    }
}


