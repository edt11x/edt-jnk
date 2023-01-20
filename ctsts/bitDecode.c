
#include <stdio.h>
#include <stdint.h>

#define SETBIT(x) ((uint32_t) (1U << (x)))

typedef void (*constPrintfFunc)(char const *x1, uint32_t x2, uint32_t x3, 
        uint32_t x4, uint32_t x5, uint32_t x6);

typedef void (*constPrintfStr)(char const *x1);

typedef struct 
{
    uint32_t firstBit;
    uint32_t lastBit;
    uint32_t value;
    uint32_t align;
    char *matchStr;
    char *noMatchStr;
} bitDecodeType;

bitDecodeType pciCmdStatDecode[] = 
{
    { SETBIT(0), SETBIT(0), SETBIT(0), 0U, "-- IO Space Enabled", "-- IO Space Disabled" },
    { 0U, 0U, 0U, 0U, NULL, NULL }  // termination record
};

static void fixedPrintfStrLn(char const *x1)
{
    printf("%s\n", x1);
}

static void decodeValue(constPrintfStr pf, bitDecodeType *bd, uint32_t value)
{
    // Only print anything if we have a list of bits to decode.
    if ((bd != NULL) && (pf != NULL))
    {
        uint32_t i;
        uint32_t thisBit;
        uint32_t mask = 0U;
        // loop through each decode record
        while (bd->firstBit != 0U)
        {
            // mask and accumulate the next bit
            for (i = 0U; i < 32U; i++)
            {
                thisBit = SETBIT(i);
                if ((thisBit >= bd->firstBit) && (thisBit <= bd->lastBit))
                {
                    mask |= thisBit;
                }
            }
            if ((value & mask) == bd->value)
            {
                if (bd->matchStr != NULL)
                {
                    (*pf)(bd->matchStr);
                }
            }
            else
            {
                if (bd->noMatchStr != NULL)
                {
                    (*pf)(bd->noMatchStr);
                }
            }
            // move to the next record
            bd++;
        }
    }
}


int32_t main()
{
    printf("Hello World!\n");
    decodeValue(fixedPrintfStrLn, pciCmdStatDecode, 0x1b7U);
}

