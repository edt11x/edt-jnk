
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFSIZE 1024

static char alloc_buf[BUFSIZE];
static char alloc_string[] = "alloc_stub(p = ";
static char alloc_scan[] = "alloc_stub(p = 0x%x";
static char free_buf[BUFSIZE];
static char free_format[] = "free_stub(p = %#x";
static char free_search[BUFSIZE];
static char free_string[] = "free_stub(p = ";

main(argc, argv)
int	argc;
char	*argv[];
{
FILE	*fp;
int	line;
int	here_line;
int	found;
int	free_size;
long	here;
long	address;

	if (argc != 2)
	{
		printf("lookatallocs alloc_file\n");
		exit(1);
	}
	if ((fp = fopen(argv[1], "r")) == (FILE *) NULL)
	{
		printf("Cant open %s, abort.\n", argv[1]);
		exit(1);
	}

	line = 0;
	for (;;)
	{
		/* look for the first occurance of alloc_stub */
		do
		{
			fgets(alloc_buf, BUFSIZE, fp);
			line++;
			if (feof(fp))
			{
				exit(0);
			}
		} while (strncmp(alloc_buf,alloc_string,sizeof(alloc_string)-1));
		/* got it , remember where we are */
		here = ftell(fp);
		here_line = line;

		/* get the address */
		address = 0;
		sscanf(alloc_buf, alloc_scan, &address);
		if (address == 0)
		{
			printf("bad address ********** == 0\n");
		}

		/* look for the matching free or end of file */
		sprintf(free_search, free_format, address);
		free_size = strlen(free_search);

		found = 0;	/* found is false */
		while (!feof(fp))
		{
			fgets(free_buf, BUFSIZE, fp);
			line++;
			if (!strncmp(free_buf, free_search, free_size))
			{
				found = 1;
				break;
			}
		} 
		
		if (found)
		{
			printf("allocation at %d, freed at %d, address %#x\n",
				here_line, line, address);
		}
		else
		{
			printf("========================================\n");
			printf("unfreed allocation at line %d, address %#x\n",
				here_line, address);
			printf("----------------------------------------\n");
			/* back to the point we left off */
			if (fseek(fp, here, 0) == -1)
			{
				printf("Oh NO, the fseek failed.\n");
				exit(1);
			}
			fputs(alloc_buf, stdout);

			do
			{
				fgets(free_buf, BUFSIZE, fp);
				fputs(free_buf, stdout);
			} while (strncmp(free_buf, alloc_string,
					sizeof(alloc_string)-1) &&
				 strncmp(free_buf, free_string,
					sizeof(free_string)-1)  &&
				 (!feof(fp)));
			printf("========================================\n");
		}
		fflush(stdout);

		/* go back to where we were before */
		line = here_line;
		rewind(fp);
		if (fseek(fp, here, 0) == -1)
		{
			printf("Oh NO, the fseek failed.\n");
			exit(1);
		}
	}
}
