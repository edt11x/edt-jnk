
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

uint32_t otp_cheap_hash32(uint32_t key)
{
    key = ~key + (key << 15);   // key = (key << 15) - key - 1;
    key = key ^ (key >> 12);
    key = key + (key << 2);
    key = key ^ (key >> 4);
    key = key * 2057U;          // key = (key + (key << 3)) + (key << 11);
    key = key ^ (key >> 16);
    return key;
}

main()
{
    uint32_t i;
    uint32_t j;
    uint32_t k;

    for (i = 0xFE000000U; i < 0xFFFFFFFFU; i++)
    {
        printf("0x%08X - 0x%08X\n", i, otp_cheap_hash32(i));
    }
    exit(0);
}

