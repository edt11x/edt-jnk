
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

static int32_t _cheap_rand_outside(uint32_t low_range, uint32_t hi_range)
{
    uint32_t rangesize = hi_range - low_range + 1;
    uint32_t r = rand() % ((RAND_MAX + 1U) - rangesize);

    if (r >= low_range)
    {
        r+= rangesize;
    }
    return r;
}


int main(void)
{
    uint32_t i;

    for (i = 0U; i < 0x0FFFFFFFU; i++)
    {
        uint32_t testval = _cheap_rand_outside(1000U, 1000000U);
        if ((testval >= 1000U) && (testval <= 1000000U))
        {
            printf("Range 1000 to 1000000, result was %u\n", testval);
        }
    }

    printf("-- %u\n", _cheap_rand_outside(0U, 1000000000U));
    printf("-- %u\n", _cheap_rand_outside(0U, 0U));
    printf("-- %u\n", _cheap_rand_outside(0U, 10U));
    return 0;
}


