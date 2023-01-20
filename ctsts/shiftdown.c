
#include <stdio.h>

typedef unsigned int UINT32;

UINT32 otp_bit_ppc_set_UINT32(UINT32 const bit)
{
        return (0x80000000U >> bit);
}


int main(void)
{
    printf(" 0 - 0x%08X\n", otp_bit_ppc_set_UINT32(0U));
    printf(" 1 - 0x%08X\n", otp_bit_ppc_set_UINT32(1U));
    printf(" 2 - 0x%08X\n", otp_bit_ppc_set_UINT32(2U));
    printf("30 - 0x%08X\n", otp_bit_ppc_set_UINT32(30U));
    printf("31 - 0x%08X\n", otp_bit_ppc_set_UINT32(31U));
}

