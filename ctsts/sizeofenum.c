
#include <stdio.h>

typedef enum 
{
    one, 
    two,
    three,
    four,
    five,
    six
} list_of_enums;

main()
{
   printf("Hello\n");
   printf("%d\n", sizeof(list_of_enums));
   exit(0);
}
