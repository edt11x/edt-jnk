
#include <stdio.h>
#include <time.h>

main()
{
    struct timespec now;
    printf("sizeof(timespec) %lu\n", sizeof(struct timespec));
    printf("sizeof(tv_sec) %lu\n", sizeof(now.tv_sec));
    printf("sizeof(tv_nsec) %lu\n", sizeof(now.tv_nsec));
}
