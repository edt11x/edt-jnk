
#include <fcntl.h>
#include <stdio.h>

int
main (void) {
    int fd = open ("/dev/dsp", O_WRONLY);
    if (fd < 0 )
    {
        perror("open(/dev/dsp) failed");
    }
    close(fd);
    return 0;
}
