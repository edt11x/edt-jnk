
#include <stdio.h>

main()
{
int a = 0xf0;
int b = 0xff;

  if (a & b != 0)
  {
    printf("true\n");
  }
}
