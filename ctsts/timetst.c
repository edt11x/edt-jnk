
#include <stdio.h>
#include <sys/time.h>
#include <time.h>

void
main()
{
    struct timeval foo;

    if (gettimeofday(&foo, NULL))
    {
	printf("blah!\n");
    }
    printf("sizeof(time_t) %d\n", sizeof(time_t));
    printf("sizeof(suseconds_t) %d\n", sizeof(suseconds_t));
    printf("seconds %d\n", foo.tv_sec);
    printf("useconds %d\n", foo.tv_usec);
    printf("seconds*1000 %d\n", foo.tv_sec*1000);
    printf("useconds/1000 %d\n", foo.tv_usec/1000);
}
