
#include <stdio.h>

main()
{
#ifdef i386
	printf("i386 is defined\n");
#else
	printf("i386 is not defined\n");
#endif
}

