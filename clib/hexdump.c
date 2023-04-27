#include <stdio.h>
#include <string.h>
#include <netinet/in.h>

void hexdump(unsigned char *buffer, int length) {
    int i, j;
    for (i = 0; i < length; i += 16) {
        printf("%06x: ", i);
        for (j = 0; j < 16; j++) {
            if (i + j < length) {
                printf("%02x ", buffer[i + j]);
            } else {
                printf("   ");
            }
        }
        printf(" ");
        for (j = 0; j < 16; j++) {
            if (i + j < length) {
                printf("%c", isprint(buffer[i + j]) ? buffer[i + j] : '.');
            }
        }
        printf("\n");
    }
}

int main(int argc, char **argv) {
    // example socket buffer data
    unsigned char buffer[] = "This is an example socket buffer.";
    int length = sizeof(buffer);

    // dump the socket buffer in hex
    hexdump(buffer, length);

    return 0;
}

