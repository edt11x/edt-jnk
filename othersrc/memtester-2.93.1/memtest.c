/*
 * Very simple (yet, for some reason, very effective) memory tester.
 * Originally by Simon Kirby <sim@stormix.com> <sim@neato.org>
 * Version 2 by Charles Cazabon <memtest@discworld.dyndns.org>
 *
 * Copyright (C) 1999 Simon Kirby.
 * Version 2 Copyright (C) 1999 Charles Cazabon.
 * Licensed under the GNU General Public License version 2.  See the file
 * COPYING for details.
 *
 * See the file ABOUT or the manpage for details.  See the file CHANGELOG
 * for changes.
 *
 */


/* Includes. */
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/mman.h>
#include <signal.h>
#include <unistd.h>
#include <ctype.h>
#include <sys/types.h>
#include <sys/time.h>
#include <sys/resource.h>

#include "memtest.h"
#include "memtest-tests.h"


/* Defines. */
#define VERSION	"2.93.1"
#define YEAR	"2000"
#define LOGFILE	"memtest.log"
#define GB		30
#define MB		20
#define KB		10
#define BYTES	0


/* Function declarations. */
void usage (char *me);
void print_summary (void);
inline void print_test_name (char *testname, ui32 *test);
int parse_opts (int argc, char **argv);
int get_mem (void);
void cleanup (int sig);
void release_mem (void);
void print_summary (void);


/* Data. */
teststruct_0 tests_noarg[] =
{
	{ "Stuck Address", test_stuck_address },
	{ "Random value", test_random_value },
	{ "XOR comparison", test_xor_comparison },
	{ "SUB comparison", test_sub_comparison },
	{ "MUL comparison", test_mul_comparison },
	{ "DIV comparison",test_div_comparison },
	{ "OR comparison", test_or_comparison },
	{ "AND comparison", test_and_comparison },
	{ "Sequential Increment", test_seqinc_comparison },
	{ "Solid Bits", test_solidbits_comparison },
	{ "Block Sequential", test_blockseq_comparison },
	{ "Checkerboard", test_checkerboard_comparison },
	{ "Bit Spread", test_bitspread_comparison },
	{ "Bit Flip", test_bitflip_comparison },
	{ NULL, 0 }
};

teststruct_1 tests_1arg[] =
{
	{ "Walking Ones",test_walkbits_comparison, 0 },
	{ "Walking Zeroes",test_walkbits_comparison, 1 },
	{ NULL, 0, 0 }
};


/* Option globals */
int opt_logtofile;

/* Logging globals */
time_t mtime1, mtime2;
FILE *logfile = NULL;

/* Stats globals */
ui32 run, maxruns, runerrors, totalerrors;

/* Memory globals */
ui8 *buf, *buf_raw, *s1, *s2;
ui32 *bp1, *bp2;
ui32 membytes, memsplit, count, waste;

/* Control globals */
int do_munlock = 1;

/* message buffer */
char msg[100];

/* rlimit structs */
struct rlimit rlim_data;
struct rlimit rlim_mlock;
struct rlimit rlim_inf = {RLIM_INFINITY, RLIM_INFINITY};

#ifdef RLIMIT_MEMLOCK
int RES_MLOCK = RLIMIT_MEMLOCK;
#else
int RES_MLOCK = RLIMIT_VMEM;
#endif

#ifdef RLIMIT_RSS
int RES_DATA = RLIMIT_RSS;
#else
int RES_DATA = RLIMIT_DATA;
#endif


/* Function definitions. */
int
main (int argc, char *argv[])
{
	ui32 testcnt, *test = &testcnt;
	int rc;
	ui32 i;
	time_t time1, time2;

	fprintf (stderr,
			 "memtest v. " VERSION "\n"
			 "(C) " YEAR " Charles Cazabon <memtest@discworld.dyndns.org>\n"
			 "Original v.1 (C) 1999 Simon Kirby <sim@stormix.com> "
			 "<sim@neato.org>\n\n");

	if (parse_opts (argc, argv))
	{
		usage (argv[0]);
		return (ERROR);
	}

	signal (SIGINT, cleanup);
	signal (SIGTERM, cleanup);
	signal (SIGQUIT, cleanup);
#ifndef DEBUGMODE
	signal (SIGHUP, SIG_IGN);
#else
	signal (SIGHUP, cleanup);
	OUTBOTH ("Running in debug mode.\n");
#endif

	/* Get old limits */
	if ((getrlimit (RES_DATA, &rlim_data) < 0) || (getrlimit (RES_MLOCK, &rlim_mlock) < 0))
	{
		OUTBOTH ("Failed to get rlimit.  Exiting...\n");
		if (logfile)
		{
			fclose (logfile);
			logfile = NULL;
		}
		exit (ERROR);
	}
	sprintf (msg, "Current limits:\n  RLIMIT_RSS  %#8lx\n  RLIMIT_VMEM %#8lx\nRaising limits...\n",
			(unsigned long) rlim_data.rlim_cur, (unsigned long) rlim_mlock.rlim_cur);
	OUTBOTH (msg);

	if ((setrlimit (RES_DATA, &rlim_inf) < 0) || (setrlimit (RES_MLOCK, &rlim_inf) < 0))
	{
		OUTBOTH ("Failed to set rlimit.  Amount of memory testable may be limited.\n");
	}

	if (get_mem ())
	{
		OUTBOTH ("Failed to get sufficient memory.  Exiting...\n");
		if (logfile)
		{
			fclose (logfile);
			logfile = NULL;
		}
		exit (ERROR);
	}

	sprintf (msg, "Testing %lu bytes at 0x%08lx (%lu bytes lost to page alignment)."
			 "\n\n", membytes, (ui32) buf, waste);
	OUTBOTH (msg);

	/* Main testing loop. */
	time (&mtime1);
	for (run = 0, *test = 1; ++run, run <= maxruns; *test = 1)
	{
		time (&time1);
		sprintf (msg, "Run %4lu:\n", run);
		OUTBOTH (msg);

		/* Do basic tests (taking two pointers plus count) here. */
		for (i = 0; ;i++)
		{
			if (tests_noarg[i].name != NULL)
			{
				print_test_name (tests_noarg[i].name, test);
				rc = tests_noarg[i].fp (bp1, bp2, count);
				if (!rc) OUTBOTH ("Passed.\n");
				else runerrors++;
			}
			else break;
		}

		/* Do other tests (taking two pointers, count, and arg) here. */
		for (i = 0; ;i++)
		{
			if (tests_1arg[i].name != NULL)
			{
				print_test_name (tests_1arg[i].name, test);
				rc = tests_1arg[i].fp (bp1, bp2, count, tests_1arg[i].arg);
				if (!rc) OUTBOTH ("Passed.\n");
				else runerrors++;
			}
			else break;
		}

		time (&time2);
		sprintf (msg, "Run %4lu completed in %lu seconds"
				" (%lu tests showed errors).\n", run, (time2 - time1),
				runerrors);
		OUTBOTH (msg);
		totalerrors += runerrors;
		runerrors = 0;
	}
	time (&mtime2);
 	release_mem ();
	print_summary ();
	return (OK);
}


int parse_opts (int argc, char **argv)
{
	int i, t;
	char *endptr;

	maxruns = ~0;
	if ((argc <= 1) || (argc >4)) return (ERROR);
	for (i = 1; i < argc; i++)
	{
		if (!membytes)
		{
			if (!strcmp (argv[i], "all"))
			{
				membytes = 4095 << MB;
				continue;
			}
			t = (ui32) strtol (argv[i], &endptr, 0);
			if (t)
			{
				switch (toupper(*endptr))
				{
					case 'B':  membytes = t << BYTES; break;
					case 'K':  membytes = t << KB; break;
					case 'G':  membytes = t << GB; break;
					case 'M':  membytes = t << MB; break;
					default:
						/* Bogus.  Note:  used to assume MB. */
						fprintf (stderr, "%s:  no units (B, K, M, G) on amount"
								 " of memory to allocate.\n", argv[0]);
						return (ERROR);
				}
				continue;
			} /* if (t) */
		} /* if !membytes */
		if (maxruns == ~0)
		{
			t = (ui32) atol (argv[i]);
			if (t) maxruns = t;
			continue;
		}
		if ((!strcmp (argv[i], "-l")) || (!strcmp (argv[i], "--log")))
		{
			opt_logtofile = 1;
			continue;
		}
	}

	/* Make sure it's a multiple of 64. */
	membytes = membytes & 0xFFFFFFC0;

	if (!membytes)
	{
		fprintf (stderr, "%s:  amount of memory to allocate too small.\n",
				 argv[0]);
		return (ERROR);
	}

	if (opt_logtofile)
	{
		logfile = fopen (LOGFILE, "w");
		if (logfile == NULL)
		{
			fprintf (stderr, "Error opening logfile:  %s\n", strerror (errno));
			return (ERROR);
		}
		fprintf (stderr, "Logging to file " LOGFILE "\n");
	}

	return (OK);
}


int
get_mem (void)
{
	int rc, pagesize;
	int do_reduce = 0, do_trylock = 1;
	ui32 pagesizemask;

	pagesize = getpagesize ();
	pagesizemask = (ui32) ~(pagesize - 1);

	while (1)
	{
		if (do_reduce)
		{
			/* Reduce proportionally. */
			if (membytes > (1UL << GB)) membytes -= (4UL << MB);
			else if (membytes > (128UL << MB)) membytes -= (1UL << MB);
			else if (membytes > (16UL << MB)) membytes -= (128UL << KB);
			else if (membytes > (2UL << MB)) membytes -= (64UL << KB);
			else if (membytes > (256UL << KB)) membytes -= (16UL << KB);
			else if (membytes > (64UL << KB)) membytes -= (4UL << KB);
			else membytes -= (1UL << KB);
		}

		/* Make sure it's a multiple of 64. */
		membytes = membytes & 0xFFFFFFC0;

		buf_raw = (ui8 *) malloc (membytes);
		if (!buf_raw)
		{
			/* Allocation failed.  Trim and try again. */
			sprintf (msg, "Unable to malloc %lu bytes.\n", membytes);
			OUTBOTH (msg);
			do_reduce = 1;
			continue;
		}

		sprintf (msg, "Allocated %lu bytes...", membytes);
		OUTBOTH (msg);

		if (do_trylock)
		{
			/* Align to page and round off. */
			OUTBOTH ("trying mlock...");
			buf = (char *) ((ui32) buf_raw & pagesizemask);
			if (buf < buf_raw) buf += pagesize;
			waste = (ui32)buf - (ui32) buf_raw;
			membytes = (membytes - waste) & 0xFFFFFFC0;
			if (membytes < pagesize)
			{
				fprintf (stderr, "failed to align to pagesize of %i bytes.\n",
						 pagesize);
				return (ERROR);
			}

		    rc = mlock (buf, membytes);
			if (!rc)
			{
				OUTBOTH ("success.  Starting tests...\n");
				goto got_mem;
			}
			switch (errno)
			{
				case EPERM:
					OUTBOTH ("failed:  only root can lock pages.\n");
					break;

				case ENOMEM:
				case EAGAIN:
					OUTBOTH ("failed:  insufficient resources.\n");
					do_reduce = 1;
					free (buf_raw);
					continue;

				default:
					sprintf (msg, "failed:  errno %i (%s).\nPlease report "
							 "this error message to the author\n", errno,
							 strerror (errno));
					OUTBOTH (msg);
					break;
			}

			do_trylock = 0;
			do_munlock = 0;
		} /* if (do_trylock) */
		OUTBOTH ("Continuing with unlocked pages.  This program runs much"
				 " faster and results\nare more reliable when running with"
				 " locked pages.\n");
		goto got_mem;
	}	/* end while */

got_mem:
	memsplit = membytes / 2;
	s1 = buf;
	s2 = buf + memsplit;
	bp1 = (ui32 *) s1;
	bp2 = (ui32 *) s2;
	count = memsplit / sizeof (ui32);

	OUTBOTH ("\n");
	return (OK);
}


void
release_mem (void)
{
	if (do_munlock)
	{
		if (!munlock (buf, membytes)) OUTBOTH ("munlock'ed memory.\n");
		else OUTBOTH ("Bizarre error while munlock'ing memory.\n");
	}
	if (buf)
	{
		free (buf_raw);
		buf = NULL;
	}
}

void
cleanup (int sig)
{
	sprintf (msg, "\nReceived signal %i (%s)\n", sig, (char *) strsignal (sig));
	OUTBOTH (msg);
	time (&mtime2);
	release_mem ();
	print_summary ();
	exit (OK);
}


void print_summary (void)
{
 	sprintf (msg, "%lu runs completed.  %lu errors detected."
			"  Total runtime:  %lu seconds.\n\n", run - 1, totalerrors,
			(mtime2 - mtime1));
	OUTBOTH (msg);
	OUTBOTH ("Exiting...\n");
	if (logfile)
	{
		fclose (logfile);
		logfile = NULL;
	}
	setrlimit (RES_DATA, &rlim_data);
	setrlimit (RES_MLOCK, &rlim_mlock);
}


void
usage (char *me)
{
	fprintf (stderr,
			"\nCopyright (C) 1999 Simon Kirby.  Version 2 Copyright (C) " YEAR " Charles Cazabon.\n"
			"This is FREE SOFTWARE, licensed under the GNU General Public License version 2.\n"
			"See the included file COPYING for details.  This software comes with absolutely\n"
			"NO WARRANTY.\n\n");
	fprintf (stderr, "Usage:\n\n%s <mem<B|K|M|G>> [runs] [-l or --log]\n"
			"    mem          - memory to test (B=bytes, K=KiB, M=MiB, G=GiB)\n"
			"                   Byte values will be rounded down to nearest multiple of 64.\n"
			"                     e.g. 2G   =  2 GiB\n"
			"                          12M  = 12 MiB\n"
			"                   Special value 'all' tests all available memory.\n"
			"    runs         - times to run tests (default: 2^32 - 1)\n"
			"    -l or --log  - log to file " LOGFILE "\n",
			me);
}


inline void
print_test_name (char *testname, ui32 *test)
{
	sprintf (msg, "  Test %2lu:  %20.20s:  Setting...", *test, testname);
	OUTBOTH (msg);
	(*test)++;
}


