#include <stdio.h>
#include <tcpd.h>

main()
{
int i = 0;

	printf("Hello world\n");
	i = hosts_ctl("smtp", "somewhere.br", "200.201.193.174", "foobar");
	printf("hosts_ctl() returns %d\n", i);
	exit(0);
}

