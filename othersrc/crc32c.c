
#include <stdio.h>
#include <stdlib.h>
/*
Copyright (C) 2010 by Ronnie Sahlberg <ronniesahlberg@gmail.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 2.1 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

#define OTP_MEM_TEST_SEED_BLOCK_SIZE (4098U*8U)

#define VID_REC_SIZE (128U*1024U*1024U)
#define VID_REC_SIZE_8M (8U*1024U*1024U)

#define VID_REC_CRC_SIZE (128U*1024U*1024U)

#define TEST_MULTIPLE (1U)

/*
 * Both CRC Tables should give the same result, one is just
 * reversed from the other. Use either one. (edt)
 */

#ifdef NOT_FOR_NOW
/*****************************************************************/
/* */
/* CRC LOOKUP TABLE */
/* ================ */
/* The following CRC lookup table was generated automagically */
/* by the Rocksoft^tm Model CRC Algorithm Table Generation */
/* Program V1.0 using the following model parameters: */
/* */
/* Width : 4 bytes. */
/* Poly : 0x1EDC6F41L */
/* Reverse : TRUE. */
/* */
/* For more information on the Rocksoft^tm Model CRC Algorithm, */
/* see the document titled "A Painless Guide to CRC Error */
/* Detection Algorithms" by Ross Williams */
/* (ross@guest.adelaide.edu.au.). This document is likely to be */
/* in the FTP archive "ftp.adelaide.edu.au/pub/rocksoft". */
/* */
/*****************************************************************/

static unsigned long crctable[256] = {
 0x00000000L, 0xF26B8303L, 0xE13B70F7L, 0x1350F3F4L,
 0xC79A971FL, 0x35F1141CL, 0x26A1E7E8L, 0xD4CA64EBL,
 0x8AD958CFL, 0x78B2DBCCL, 0x6BE22838L, 0x9989AB3BL,
 0x4D43CFD0L, 0xBF284CD3L, 0xAC78BF27L, 0x5E133C24L,
 0x105EC76FL, 0xE235446CL, 0xF165B798L, 0x030E349BL,
 0xD7C45070L, 0x25AFD373L, 0x36FF2087L, 0xC494A384L,
 0x9A879FA0L, 0x68EC1CA3L, 0x7BBCEF57L, 0x89D76C54L,
 0x5D1D08BFL, 0xAF768BBCL, 0xBC267848L, 0x4E4DFB4BL,
 0x20BD8EDEL, 0xD2D60DDDL, 0xC186FE29L, 0x33ED7D2AL,
 0xE72719C1L, 0x154C9AC2L, 0x061C6936L, 0xF477EA35L,
 0xAA64D611L, 0x580F5512L, 0x4B5FA6E6L, 0xB93425E5L,
 0x6DFE410EL, 0x9F95C20DL, 0x8CC531F9L, 0x7EAEB2FAL,
 0x30E349B1L, 0xC288CAB2L, 0xD1D83946L, 0x23B3BA45L,
 0xF779DEAEL, 0x05125DADL, 0x1642AE59L, 0xE4292D5AL,
 0xBA3A117EL, 0x4851927DL, 0x5B016189L, 0xA96AE28AL,
 0x7DA08661L, 0x8FCB0562L, 0x9C9BF696L, 0x6EF07595L,
 0x417B1DBCL, 0xB3109EBFL, 0xA0406D4BL, 0x522BEE48L,
 0x86E18AA3L, 0x748A09A0L, 0x67DAFA54L, 0x95B17957L,
 0xCBA24573L, 0x39C9C670L, 0x2A993584L, 0xD8F2B687L,
 0x0C38D26CL, 0xFE53516FL, 0xED03A29BL, 0x1F682198L,
 0x5125DAD3L, 0xA34E59D0L, 0xB01EAA24L, 0x42752927L,
 0x96BF4DCCL, 0x64D4CECFL, 0x77843D3BL, 0x85EFBE38L,
 0xDBFC821CL, 0x2997011FL, 0x3AC7F2EBL, 0xC8AC71E8L,
 0x1C661503L, 0xEE0D9600L, 0xFD5D65F4L, 0x0F36E6F7L,
 0x61C69362L, 0x93AD1061L, 0x80FDE395L, 0x72966096L,
 0xA65C047DL, 0x5437877EL, 0x4767748AL, 0xB50CF789L,
 0xEB1FCBADL, 0x197448AEL, 0x0A24BB5AL, 0xF84F3859L,
 0x2C855CB2L, 0xDEEEDFB1L, 0xCDBE2C45L, 0x3FD5AF46L,
 0x7198540DL, 0x83F3D70EL, 0x90A324FAL, 0x62C8A7F9L,
 0xB602C312L, 0x44694011L, 0x5739B3E5L, 0xA55230E6L,
 0xFB410CC2L, 0x092A8FC1L, 0x1A7A7C35L, 0xE811FF36L,
 0x3CDB9BDDL, 0xCEB018DEL, 0xDDE0EB2AL, 0x2F8B6829L,
 0x82F63B78L, 0x709DB87BL, 0x63CD4B8FL, 0x91A6C88CL,
 0x456CAC67L, 0xB7072F64L, 0xA457DC90L, 0x563C5F93L,
 0x082F63B7L, 0xFA44E0B4L, 0xE9141340L, 0x1B7F9043L,
 0xCFB5F4A8L, 0x3DDE77ABL, 0x2E8E845FL, 0xDCE5075CL,
 0x92A8FC17L, 0x60C37F14L, 0x73938CE0L, 0x81F80FE3L,
 0x55326B08L, 0xA759E80BL, 0xB4091BFFL, 0x466298FCL,
 0x1871A4D8L, 0xEA1A27DBL, 0xF94AD42FL, 0x0B21572CL,
 0xDFEB33C7L, 0x2D80B0C4L, 0x3ED04330L, 0xCCBBC033L,
 0xA24BB5A6L, 0x502036A5L, 0x4370C551L, 0xB11B4652L,
 0x65D122B9L, 0x97BAA1BAL, 0x84EA524EL, 0x7681D14DL,
 0x2892ED69L, 0xDAF96E6AL, 0xC9A99D9EL, 0x3BC21E9DL,
 0xEF087A76L, 0x1D63F975L, 0x0E330A81L, 0xFC588982L,
 0xB21572C9L, 0x407EF1CAL, 0x532E023EL, 0xA145813DL,
 0x758FE5D6L, 0x87E466D5L, 0x94B49521L, 0x66DF1622L,
 0x38CC2A06L, 0xCAA7A905L, 0xD9F75AF1L, 0x2B9CD9F2L,
 0xFF56BD19L, 0x0D3D3E1AL, 0x1E6DCDEEL, 0xEC064EEDL,
 0xC38D26C4L, 0x31E6A5C7L, 0x22B65633L, 0xD0DDD530L,
 0x0417B1DBL, 0xF67C32D8L, 0xE52CC12CL, 0x1747422FL,
 0x49547E0BL, 0xBB3FFD08L, 0xA86F0EFCL, 0x5A048DFFL,
 0x8ECEE914L, 0x7CA56A17L, 0x6FF599E3L, 0x9D9E1AE0L,
 0xD3D3E1ABL, 0x21B862A8L, 0x32E8915CL, 0xC083125FL,
 0x144976B4L, 0xE622F5B7L, 0xF5720643L, 0x07198540L,
 0x590AB964L, 0xAB613A67L, 0xB831C993L, 0x4A5A4A90L,
 0x9E902E7BL, 0x6CFBAD78L, 0x7FAB5E8CL, 0x8DC0DD8FL,
 0xE330A81AL, 0x115B2B19L, 0x020BD8EDL, 0xF0605BEEL,
 0x24AA3F05L, 0xD6C1BC06L, 0xC5914FF2L, 0x37FACCF1L,
 0x69E9F0D5L, 0x9B8273D6L, 0x88D28022L, 0x7AB90321L,
 0xAE7367CAL, 0x5C18E4C9L, 0x4F48173DL, 0xBD23943EL,
 0xF36E6F75L, 0x0105EC76L, 0x12551F82L, 0xE03E9C81L,
 0x34F4F86AL, 0xC69F7B69L, 0xD5CF889DL, 0x27A40B9EL,
 0x79B737BAL, 0x8BDCB4B9L, 0x988C474DL, 0x6AE7C44EL,
 0xBE2DA0A5L, 0x4C4623A6L, 0x5F16D052L, 0xAD7D5351L
};

unsigned long crc32c(char *buf, int len)
{
        unsigned long crc = 0xffffffff;
        while (len-- > 0) {
                crc = (crc>>8) ^ crctable[(crc ^ (*buf++)) & 0xFF];
        }
        return crc^0xffffffff;
}
#endif /* #ifdef NOT_FOR_NOW */
/*
 *  Castagnoli CRC32C Checksum Algorithm
 *
 *  Polynomial: 0x11EDC6F41
 *
 *  Castagnoli93: Guy Castagnoli and Stefan Braeuer and Martin Herrman
 *               "Optimization of Cyclic Redundancy-Check Codes with 24
 *                 and 32 Parity Bits",IEEE Transactions on Communication,
 *                Volume 41, Number 6, June 1993
 *
 *  Copyright (c) 2013 Red Hat, Inc.,
 *
 *  Authors:
 *   Jeff Cody <jcody@redhat.com>
 *
 *  Based on the Linux kernel cryptographic crc32c module,
 *
 *  Copyright (c) 2004 Cisco Systems, Inc.
 *  Copyright (c) 2008 Herbert Xu <herbert@gondor.apana.org.au>
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2 of the License, or (at your option)
 * any later version.
 *
 */

/*
 * This is the CRC-32C table
 * Generated with:
 * width = 32 bits
 * poly = 0x1EDC6F41
 * reflect input bytes = true
 * reflect output bytes = true
 */

static const unsigned int crc32c_table[256] = {
    0x00000000L, 0xF26B8303L, 0xE13B70F7L, 0x1350F3F4L,
    0xC79A971FL, 0x35F1141CL, 0x26A1E7E8L, 0xD4CA64EBL,
    0x8AD958CFL, 0x78B2DBCCL, 0x6BE22838L, 0x9989AB3BL,
    0x4D43CFD0L, 0xBF284CD3L, 0xAC78BF27L, 0x5E133C24L,
    0x105EC76FL, 0xE235446CL, 0xF165B798L, 0x030E349BL,
    0xD7C45070L, 0x25AFD373L, 0x36FF2087L, 0xC494A384L,
    0x9A879FA0L, 0x68EC1CA3L, 0x7BBCEF57L, 0x89D76C54L,
    0x5D1D08BFL, 0xAF768BBCL, 0xBC267848L, 0x4E4DFB4BL,
    0x20BD8EDEL, 0xD2D60DDDL, 0xC186FE29L, 0x33ED7D2AL,
    0xE72719C1L, 0x154C9AC2L, 0x061C6936L, 0xF477EA35L,
    0xAA64D611L, 0x580F5512L, 0x4B5FA6E6L, 0xB93425E5L,
    0x6DFE410EL, 0x9F95C20DL, 0x8CC531F9L, 0x7EAEB2FAL,
    0x30E349B1L, 0xC288CAB2L, 0xD1D83946L, 0x23B3BA45L,
    0xF779DEAEL, 0x05125DADL, 0x1642AE59L, 0xE4292D5AL,
    0xBA3A117EL, 0x4851927DL, 0x5B016189L, 0xA96AE28AL,
    0x7DA08661L, 0x8FCB0562L, 0x9C9BF696L, 0x6EF07595L,
    0x417B1DBCL, 0xB3109EBFL, 0xA0406D4BL, 0x522BEE48L,
    0x86E18AA3L, 0x748A09A0L, 0x67DAFA54L, 0x95B17957L,
    0xCBA24573L, 0x39C9C670L, 0x2A993584L, 0xD8F2B687L,
    0x0C38D26CL, 0xFE53516FL, 0xED03A29BL, 0x1F682198L,
    0x5125DAD3L, 0xA34E59D0L, 0xB01EAA24L, 0x42752927L,
    0x96BF4DCCL, 0x64D4CECFL, 0x77843D3BL, 0x85EFBE38L,
    0xDBFC821CL, 0x2997011FL, 0x3AC7F2EBL, 0xC8AC71E8L,
    0x1C661503L, 0xEE0D9600L, 0xFD5D65F4L, 0x0F36E6F7L,
    0x61C69362L, 0x93AD1061L, 0x80FDE395L, 0x72966096L,
    0xA65C047DL, 0x5437877EL, 0x4767748AL, 0xB50CF789L,
    0xEB1FCBADL, 0x197448AEL, 0x0A24BB5AL, 0xF84F3859L,
    0x2C855CB2L, 0xDEEEDFB1L, 0xCDBE2C45L, 0x3FD5AF46L,
    0x7198540DL, 0x83F3D70EL, 0x90A324FAL, 0x62C8A7F9L,
    0xB602C312L, 0x44694011L, 0x5739B3E5L, 0xA55230E6L,
    0xFB410CC2L, 0x092A8FC1L, 0x1A7A7C35L, 0xE811FF36L,
    0x3CDB9BDDL, 0xCEB018DEL, 0xDDE0EB2AL, 0x2F8B6829L,
    0x82F63B78L, 0x709DB87BL, 0x63CD4B8FL, 0x91A6C88CL,
    0x456CAC67L, 0xB7072F64L, 0xA457DC90L, 0x563C5F93L,
    0x082F63B7L, 0xFA44E0B4L, 0xE9141340L, 0x1B7F9043L,
    0xCFB5F4A8L, 0x3DDE77ABL, 0x2E8E845FL, 0xDCE5075CL,
    0x92A8FC17L, 0x60C37F14L, 0x73938CE0L, 0x81F80FE3L,
    0x55326B08L, 0xA759E80BL, 0xB4091BFFL, 0x466298FCL,
    0x1871A4D8L, 0xEA1A27DBL, 0xF94AD42FL, 0x0B21572CL,
    0xDFEB33C7L, 0x2D80B0C4L, 0x3ED04330L, 0xCCBBC033L,
    0xA24BB5A6L, 0x502036A5L, 0x4370C551L, 0xB11B4652L,
    0x65D122B9L, 0x97BAA1BAL, 0x84EA524EL, 0x7681D14DL,
    0x2892ED69L, 0xDAF96E6AL, 0xC9A99D9EL, 0x3BC21E9DL,
    0xEF087A76L, 0x1D63F975L, 0x0E330A81L, 0xFC588982L,
    0xB21572C9L, 0x407EF1CAL, 0x532E023EL, 0xA145813DL,
    0x758FE5D6L, 0x87E466D5L, 0x94B49521L, 0x66DF1622L,
    0x38CC2A06L, 0xCAA7A905L, 0xD9F75AF1L, 0x2B9CD9F2L,
    0xFF56BD19L, 0x0D3D3E1AL, 0x1E6DCDEEL, 0xEC064EEDL,
    0xC38D26C4L, 0x31E6A5C7L, 0x22B65633L, 0xD0DDD530L,
    0x0417B1DBL, 0xF67C32D8L, 0xE52CC12CL, 0x1747422FL,
    0x49547E0BL, 0xBB3FFD08L, 0xA86F0EFCL, 0x5A048DFFL,
    0x8ECEE914L, 0x7CA56A17L, 0x6FF599E3L, 0x9D9E1AE0L,
    0xD3D3E1ABL, 0x21B862A8L, 0x32E8915CL, 0xC083125FL,
    0x144976B4L, 0xE622F5B7L, 0xF5720643L, 0x07198540L,
    0x590AB964L, 0xAB613A67L, 0xB831C993L, 0x4A5A4A90L,
    0x9E902E7BL, 0x6CFBAD78L, 0x7FAB5E8CL, 0x8DC0DD8FL,
    0xE330A81AL, 0x115B2B19L, 0x020BD8EDL, 0xF0605BEEL,
    0x24AA3F05L, 0xD6C1BC06L, 0xC5914FF2L, 0x37FACCF1L,
    0x69E9F0D5L, 0x9B8273D6L, 0x88D28022L, 0x7AB90321L,
    0xAE7367CAL, 0x5C18E4C9L, 0x4F48173DL, 0xBD23943EL,
    0xF36E6F75L, 0x0105EC76L, 0x12551F82L, 0xE03E9C81L,
    0x34F4F86AL, 0xC69F7B69L, 0xD5CF889DL, 0x27A40B9EL,
    0x79B737BAL, 0x8BDCB4B9L, 0x988C474DL, 0x6AE7C44EL,
    0xBE2DA0A5L, 0x4C4623A6L, 0x5F16D052L, 0xAD7D5351L
};


unsigned int crc32c(const char *data, unsigned int length)
{
    unsigned long crc = 0xffffffff;
    while (length--) {
        crc = crc32c_table[(crc ^ *data++) & 0xFFL] ^ (crc >> 8);
    }
    return crc^0xffffffff;
}

/*
 * RFC 3720 has some examples of how the CRCs should work out
 */
// unsigned char buf[VID_REC_SIZE + (6U * 8U)];
unsigned char *buf;

int main(void)
{
    unsigned char *p;
    int i;
    unsigned long computed;
    unsigned long expected;
//    32 bytes of zeroes:
// 
//      Byte:        0  1  2  3
// 
//         0:       00 00 00 00
//       ...
//        28:       00 00 00 00
// 
//       CRC:       aa 36 91 8a

    buf = malloc(VID_REC_SIZE + (6U * 8U));
    
    for (i = 0; i < 32; i++)
    {
        buf[i] = 0;
    }
    expected = 0x8a9136aaUL;
    computed = crc32c(buf, 32);
    printf("Expected 0x%08X, Got 0x%08X -- %s\n", expected, computed,
            (computed == expected) ? "matched" : "**** FAILED ****");

//    32 bytes of ones:
// 
//      Byte:        0  1  2  3
// 
//         0:       ff ff ff ff
//       ...
//        28:       ff ff ff ff
// 
//       CRC:       43 ab a8 62
//     

    for (i = 0; i < 32; i++)
    {
        buf[i] = 0xff;
    }
    expected = 0x62a8ab43UL;
    computed = crc32c(buf, 32);
    printf("Expected 0x%08X, Got 0x%08X -- %s\n", expected, computed,
            (computed == expected) ? "matched" : "**** FAILED ****");

//    32 bytes of incrementing 00..1f:
// 
//      Byte:        0  1  2  3
// 
//         0:       00 01 02 03
//       ...
//        28:       1c 1d 1e 1f
// 
//       CRC:       4e 79 dd 46

    for (i = 0; i < 32; i++)
    {
        buf[i] = i;
    }
    expected = 0x46dd794eUL;
    computed = crc32c(buf, 32);
    printf("Expected 0x%08X, Got 0x%08X -- %s\n", expected, computed,
            (computed == expected) ? "matched" : "**** FAILED ****");

//    32 bytes of decrementing 1f..00:
// 
//      Byte:        0  1  2  3
// 
//         0:       1f 1e 1d 1c
//       ...
//        28:       03 02 01 00
// 
//       CRC:       5c db 3f 11

    for (i = 0; i < 32; i++)
    {
        buf[i] = 0x1f - i;
    }
    expected = 0x113fdb5cUL;
    computed = crc32c(buf, 32);
    printf("Expected 0x%08X, Got 0x%08X -- %s\n", expected, computed,
            (computed == expected) ? "matched" : "**** FAILED ****");
    printf("\n\n");

    // JSF OTP Patterns

    printf("Seed Buffer Calcuations\n");
    p = buf;
    for (i = 0; i < OTP_MEM_TEST_SEED_BLOCK_SIZE * TEST_MULTIPLE; i+=3)
    {
        int j;
        for (j = 0; j < 8; j++) *p++ = 0x55;
        for (j = 0; j < 8; j++) *p++ = 0xAA;
        for (j = 0; j < 8; j++) *p++ = 0xFF;
    }
    computed = crc32c(buf, OTP_MEM_TEST_SEED_BLOCK_SIZE * TEST_MULTIPLE*8);
    printf("Test Pattern 0 : 0x%08X\n", computed);

    p = buf;
    for (i = 0; i < OTP_MEM_TEST_SEED_BLOCK_SIZE * TEST_MULTIPLE; i+=3)
    {
        int j;
        for (j = 0; j < 8; j++) *p++ = 0xAA;
        for (j = 0; j < 8; j++) *p++ = 0xFF;
        for (j = 0; j < 8; j++) *p++ = 0x55;
    }
    computed = crc32c(buf, OTP_MEM_TEST_SEED_BLOCK_SIZE * TEST_MULTIPLE*8);
    printf("Test Pattern 1 : 0x%08X\n", computed);

    p = buf;
    for (i = 0; i < OTP_MEM_TEST_SEED_BLOCK_SIZE * TEST_MULTIPLE; i+=3)
    {
        int j;
        for (j = 0; j < 8; j++) *p++ = 0xFF;
        for (j = 0; j < 8; j++) *p++ = 0x55;
        for (j = 0; j < 8; j++) *p++ = 0xAA;
    }
    computed = crc32c(buf, OTP_MEM_TEST_SEED_BLOCK_SIZE * TEST_MULTIPLE*8);
    printf("Test Pattern 2 : 0x%08X\n", computed);

    p = buf;
    for (i = 0; i < OTP_MEM_TEST_SEED_BLOCK_SIZE * TEST_MULTIPLE; i+=3)
    {
        int j;
        for (j = 0; j < 8; j++) *p++ = 0x55;
        for (j = 0; j < 8; j++) *p++ = 0xAA;
        for (j = 0; j < 8; j++) *p++ = 0x00;
    }
    computed = crc32c(buf, OTP_MEM_TEST_SEED_BLOCK_SIZE * TEST_MULTIPLE*8);
    printf("Test Pattern 3 : 0x%08X\n", computed);

    p = buf;
    for (i = 0; i < OTP_MEM_TEST_SEED_BLOCK_SIZE * TEST_MULTIPLE; i+=3)
    {
        int j;
        for (j = 0; j < 8; j++) *p++ = 0xAA;
        for (j = 0; j < 8; j++) *p++ = 0x00;
        for (j = 0; j < 8; j++) *p++ = 0x55;
    }
    computed = crc32c(buf, OTP_MEM_TEST_SEED_BLOCK_SIZE * TEST_MULTIPLE*8);
    printf("Test Pattern 4 : 0x%08X\n", computed);

    p = buf;
    for (i = 0; i < OTP_MEM_TEST_SEED_BLOCK_SIZE * TEST_MULTIPLE; i+=3)
    {
        int j;
        for (j = 0; j < 8; j++) *p++ = 0x00;
        for (j = 0; j < 8; j++) *p++ = 0x55;
        for (j = 0; j < 8; j++) *p++ = 0xAA;
    }
    computed = crc32c(buf, OTP_MEM_TEST_SEED_BLOCK_SIZE * TEST_MULTIPLE*8);
    printf("Test Pattern 5 : 0x%08X\n", computed);

    printf("\n\n");

    // 64 Meg buffers

    printf("Video Recording Buffers\n");
    p = buf;
    for (i = 0; i < VID_REC_SIZE/8U; i+=3)
    {
        int j;
        for (j = 0; j < 8; j++) *p++ = 0x55;
        for (j = 0; j < 8; j++) *p++ = 0xAA;
        for (j = 0; j < 8; j++) *p++ = 0xFF;
    }
    printf("Buffer is built\n");
    computed = crc32c(buf, VID_REC_CRC_SIZE);
    printf("Test Pattern 0 : 0x%08X\n", computed);

    p = buf;
    for (i = 0; i < VID_REC_SIZE/8U; i+=3)
    {
        int j;
        for (j = 0; j < 8; j++) *p++ = 0xAA;
        for (j = 0; j < 8; j++) *p++ = 0xFF;
        for (j = 0; j < 8; j++) *p++ = 0x55;
    }
    computed = crc32c(buf, VID_REC_CRC_SIZE);
    printf("Test Pattern 1 : 0x%08X\n", computed);

    p = buf;
    for (i = 0; i < VID_REC_SIZE/8U; i+=3)
    {
        int j;
        for (j = 0; j < 8; j++) *p++ = 0xFF;
        for (j = 0; j < 8; j++) *p++ = 0x55;
        for (j = 0; j < 8; j++) *p++ = 0xAA;
    }
    computed = crc32c(buf, VID_REC_CRC_SIZE);
    printf("Test Pattern 2 : 0x%08X\n", computed);

    p = buf;
    for (i = 0; i < VID_REC_SIZE/8U; i+=3)
    {
        int j;
        for (j = 0; j < 8; j++) *p++ = 0x55;
        for (j = 0; j < 8; j++) *p++ = 0xAA;
        for (j = 0; j < 8; j++) *p++ = 0x00;
    }
    computed = crc32c(buf, VID_REC_CRC_SIZE);
    printf("Test Pattern 3 : 0x%08X\n", computed);

    p = buf;
    for (i = 0; i < VID_REC_SIZE/8U; i+=3)
    {
        int j;
        for (j = 0; j < 8; j++) *p++ = 0xAA;
        for (j = 0; j < 8; j++) *p++ = 0x00;
        for (j = 0; j < 8; j++) *p++ = 0x55;
    }
    computed = crc32c(buf, VID_REC_CRC_SIZE);
    printf("Test Pattern 4 : 0x%08X\n", computed);

    p = buf;
    for (i = 0; i < VID_REC_SIZE/8U; i+=3)
    {
        int j;
        for (j = 0; j < 8; j++) *p++ = 0x00;
        for (j = 0; j < 8; j++) *p++ = 0x55;
        for (j = 0; j < 8; j++) *p++ = 0xAA;
    }
    computed = crc32c(buf, VID_REC_CRC_SIZE);
    printf("Test Pattern 5 : 0x%08X\n", computed);

    printf("\n\n");

    exit(0);
}

