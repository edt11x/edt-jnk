/*
 * Very simple (yet, for some reason, very effective) memory tester.
 * Originally by Simon Kirby <sim@stormix.com> <sim@neato.org>
 * Version 2 by Charles Cazabon <memtest@discworld.dyndns.org>
 *
 * This file contains the function declarations for the ancillary routines,
 * and datatype definitions.  See ABOUT, CHANGELOG, and the manpage for
 * details.
 *
 */

#ifndef _MEMTEST_H
#define _MEMTEST_H


/* Includes. */
#ifdef DEBUGMODE
#	include "checkpoint.h"
#endif


/* Defines. */
#define OK			0
#define ERROR		-1
#define RAND32		(ui32) ( (ui32) rand () | ( (ui32) rand () << 16))
#define MAKE32FROM8(X)	(ui32) (X | X << 8 | X << 16 | X << 24)
#define MAX(a,b)	( (a > b) ? a : b )
#define OUTLOG(X)	if (logfile != NULL) do \
	{ \
		fprintf (logfile, X); \
		fflush (logfile); \
	} while (0)
#define OUTBOTH(X)	do \
	{ \
		fprintf (stderr, X); \
		OUTLOG(X); \
	} while (0)

#ifndef DEBUGMODE
#	define CHECKPOINT	do { ; } while (0)
#endif

/* Datatypes. */
typedef struct teststruct_noarg
{
	char *name;
	int (*fp)();
} teststruct_0;

typedef struct teststruct_onearg
{
	char *name;
	int (*fp)();
	int arg;
} teststruct_1;

typedef	unsigned char	ui8;
typedef unsigned long	ui32;

#endif /* _MEMTEST_H */

