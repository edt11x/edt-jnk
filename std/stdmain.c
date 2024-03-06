
#include <stdio.h>
#include "edt.h"

/******************************************************************************


NAME:   



AUTHOR: Edward Thompson

DATE:   Tue Oct 13 18:06:56 EDT 1987

DESIGN CONTROL: Advanced Programming Resolutions, Inc.

ABSTRACT:	

DESCRIPTION:    

RESTRICTIONS:   

WARNINGS:

MODIFICATION HISTORY:

05/11/87	Began this module.
                                                                         (edt)
******************************************************************************/


/*---------------------------------------------------------------------------*/
/*                              Module Globals                               */
/*---------------------------------------------------------------------------*/

#define VERSION "program_name (short_desription) Version 0.00a\n"


/*****************************************************************************
 *
 *  NAME
 *
 *  SYNOPSIS
 *
 *  DESCRIPTION
 *
 *  PASSED PARAMETERS
 *
 *  FUNCTIONS CALLED
 *
 *  CALLING FUNCTIONS
 *
 *  RETURN VALUE
 *
 *  SEE ALSO
 *
 *  WARNINGS
 *
 *                                                                       (edt)
 *****************************************************************************/


/******************************************************************************

  NAME

  SYNOPSIS

  DESCRIPTION

  AUTHOR

  DATE

  SEE ALSO
                                                                         (edt)
******************************************************************************/


main(argc, argv)
int	argc;
char	*argv[];
{
int	c;
extern	char	*optarg;
extern	int	optind;
FILE	*fp;

	while((c = getopt(argc, argv, "?v")) != EOF)
		switch(c) 
		{
			case '?':
				usage();
				exit(1);
				break;
			case 'v':
				printf(VERSION);
				exit(0);
				break;
			default:
				usage();
				exit(1);
				break;
		}
	if (optind < argc)
	{
		for (; optind < argc; optind++)
		{
			if ((fp = fopen(argv[optind], "r"))
				== (FILE *) NULL)
			{
				fprintf(stderr, "Could Not Open %s in %s.\n",
					argv[optind], argv[0]);
			}
			else
			{
				do_command(fp);
				fclose(fp);
			}
		}
	}
	else
	{
		do_command(stdin);
	}
}

