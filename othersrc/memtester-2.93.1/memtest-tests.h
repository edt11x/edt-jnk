/*
 * Very simple (yet, for some reason, very effective) memory tester.
 * Originally by Simon Kirby <sim@stormix.com> <sim@neato.org>
 * Version 2 by Charles Cazabon <memtest@discworld.dyndns.org>
 *
 * This file contains the function declarations for the actual tests.
 * See ABOUT, CHANGELOG, and the manpage for details.
 *
 */

#ifndef _MEMTEST_TESTS_H
#define _MEMTEST_TESTS_H

/* Includes. */
#include "memtest.h"


/* Defines. */


/* Function declarations. */
int test_verify_success (ui32 *bp1, ui32 *bp2, ui32 count);
int test_random_value (ui32 *bp1, ui32 *bp2, ui32 count);
int test_xor_comparison (ui32 *bp1, ui32 *bp2, ui32 count);
int test_sub_comparison (ui32 *bp1, ui32 *bp2, ui32 count);
int test_mul_comparison (ui32 *bp1, ui32 *bp2, ui32 count);
int test_div_comparison (ui32 *bp1, ui32 *bp2, ui32 count);
int test_or_comparison (ui32 *bp1, ui32 *bp2, ui32 count);
int test_and_comparison (ui32 *bp1, ui32 *bp2, ui32 count);
int test_seqinc_comparison (ui32 *bp1, ui32 *bp2, ui32 count);
int test_checkerboard_comparison (ui32 *bp1, ui32 *bp2, ui32 count);
int test_solidbits_comparison (ui32 *bp1, ui32 *bp2, ui32 count);
int test_blockseq_comparison (ui32 *bp1, ui32 *bp2, ui32 count);
int test_walkbits_comparison (ui32 *bp1, ui32 *bp2, ui32 count, int mode);
int test_bitspread_comparison (ui32 *bp1, ui32 *bp2, ui32 count);
int test_bitflip_comparison (ui32 *bp1, ui32 *bp2, ui32 count);
int test_stuck_address (ui32 *bp1, ui32 *bp2, ui32 count);


#endif /* _MEMTEST_TESTS_H */
