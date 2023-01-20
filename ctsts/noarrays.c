
#include <stdio.h>

main()
{
  /* An array of pointers to integers */
  int *array[10];
 
  int array2[] = { 2, 3, 4, 5 };

  struct foo
  {
    int a;
    float b;
  } array3[] = { { 1, 1.0 }, { 2, 2.0 } };

  int a = 0; /* 0 */
  int b = 1;
  int c = 2;
  int d = 3;
  int e = 4; /* 4 */
  int f = 5;
  int g = 6;
  int h = 7;
  int i = 8;
  int j = 9; /* 9 */

  array[0] = &a;
  array[1] = &b;
  array[2] = &c;
  array[3] = &d;
  array[4] = &e;
  array[5] = &f;
  array[6] = &g;
  array[7] = &h;
  array[8] = &i;
  array[9] = &j;

  printf("This will print 4 %d\n", *array[4]);
  printf("This will print 4 %d\n", *4[array]);
  printf("This will print 4 %d\n", **(array + 4));
}

